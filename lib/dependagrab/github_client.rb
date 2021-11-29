require './lib/dependagrab/gh_api'

module Dependagrab
  class GithubClient

    attr_reader :repo, :owner, :token

    def initialize(options={})
      @repo = options.fetch(:repo)
      @owner = options.fetch(:owner)
      @token = options[:token] || default_github_token
    end

    def grab
      result = {
        alerts: []
      }
      query_variables = { repo: repo, owner: owner }

      has_next_page = true # always run query at least once
      while(has_next_page)
        response = GHAPI::Client.query(GHAPI::Query,
                                      variables: query_variables,
                                      context: { api_token: token }
                                     )
        validate_response!(response)

        response.original_hash['data']['repository']['vulnerabilityAlerts']['nodes'].each do |alert|
          result[:alerts].append(
            parse_alert(alert)
          )
        end

        # Sets the last position for pagination
        query_variables[:after_cursor] = response.data.repository.vulnerability_alerts.page_info.end_cursor

        has_next_page = response.data.repository.vulnerability_alerts.page_info.has_next_page
      end

      result
    end

    private


    def validate_response!(response)
      if response.errors.messages.any?
        raise GhApiError.new("GitHub API Error(s): " + response.errors.messages.values.join("\n"))
      end

      if response.original_hash['errors'] && response.original_hash['errors'].any?
        raise Error.new(response.original_hash['errors'].map { |e| e['message'] })
      end
    end

    # Converts response format to hash
    #
    def parse_alert(alert)
      vuln = alert['securityVulnerability']

      {}.tap do |finding|
        finding[:id] = vuln['advisory']['id']
        finding[:ghsa_id] = vuln['advisory']['ghsaId']
        finding[:package_name] = vuln['package']['name']
        finding[:ecosystem] = vuln['package']['ecosystem']
        finding[:severity] = vuln['advisory']['severity']
        finding[:cvss_vector] = vuln['advisory']['cvss']['vectorString']
        finding[:cvss] = vuln['advisory']['cvss']['score']
        finding[:permalink] = vuln['advisory']['permalink']
        finding[:summary] = vuln['advisory']['summary']
        finding[:description] = vuln['advisory']['description']
        finding[:vulnerable_version_range] = vuln['vulnerableVersionRange']
        finding[:first_patched_version] = vuln['firstPatchedVersion']

        if vuln['advisory']['cwes']['edges'].any?
          cwe = vuln['advisory']['cwes']['edges'][0]
          finding[:cwe] = cwe['node']['cweId']
          finding[:cw_name] = cwe['node']['name']
        end
      end
    end

    def default_github_token
      begin
        ENV.fetch("GITHUB_API_TOKEN")
      rescue
        raise MissingConfigError.new("GitHub API token is not configured")
      end
    end
  end
end
