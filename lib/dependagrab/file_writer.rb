require 'securerandom'

module Dependagrab
  # For writing output in to a file in a json format
  # format is aligned to ThreadFix(https://denimgroup.atlassian.net/wiki/spaces/TDOC/pages/496009270/ThreadFix+File+Format)
  #
  class FileWriter

    # Destination to write file
    attr_accessor :output_file

    def initialize(output_file)
      @output_file = output_file
    end

    def write!(result)
      scan = scan_meta_data

      result.each do |alert|
        scan[:findings].append(
          parse_threadfix_finding(alert)
        )
      end

      File.open(output_file, "w") do |f|
        f.write(scan.to_json)
      end
    end


    private

    def scan_meta_data
      {
        id: SecureRandom.uuid,
        created: Time.now.strftime('%Y-%m-%dT%H:%M:%SZ'),
        exported: Time.now.strftime('%Y-%m-%dT%H:%M:%SZ'),
        source: "AppSec Team",
        collectionType: "DEPENDENCY",
        findings: [],
      }
    end

    # Converts an alert into a ThreadFix finding format
    #
    def parse_threadfix_finding(alert)
      {
        nativeId: alert[:id],
        severity: alert[:severity].gsub("MODERATE", "MEDIUM"),
        nativeSeverity: alert[:severity].gsub("MODERATE", "MEDIUM"),
        summary: alert[:summary],
        cvsScore: alert[:cvss],
        description: alert[:description],
        dependencyDetails: {
          library: alert[:package_name],
          description: alert[:description],
          reference: alert[:ghsa_id],
          referenceLink: alert[:permalink],
          version: alert[:vulnerable_version_range],
          issueType: "VULNERABILITY",
        },
        mappings: [
          {
            mappingType: "CWE",
            value: alert[:cwe][4..],
          }
        ]
      }
    end
  end
end
