require "graphql/client"
require "graphql/client/http"

module Dependagrab
  module GHAPI
    GRAPHQL_API = "https://api.github.com/graphql"
    SCHEMA_PATH = File.join(File.expand_path('../../', File.dirname(__FILE__)), "static/gh_schema.json")

    # Configure GraphQL endpoint using the basic HTTP network adapter.
    HTTP = GraphQL::Client::HTTP.new(GRAPHQL_API) do
      def headers(context)
        # Optionally set any HTTP headers
        {
          "User-Agent": "dependagrab #{Dependagrab::VERSION}",
        }.tap do |h|
          if context[:api_token]
            h["Authorization"] = "bearer #{context[:api_token]}"
          end
        end
      end
    end

    # However, it's smart to dump this to a JSON file and load from disk
    #
    # Run it from a script or rake task
    # GraphQL::Client.dump_schema(GHAPI::HTTP, "gh_schema.json")
    Schema = GraphQL::Client.load_schema(SCHEMA_PATH)

    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

    Query = Client.parse <<-'GRAPHQL'
    query($repo: String!, $owner: String!, $after_cursor: String) {
     repository(name: $repo, owner: $owner) {
       vulnerabilityAlerts(first: 20, after: $after_cursor) {
         pageInfo {
           endCursor
           hasNextPage
         }
         nodes {

           securityVulnerability {
             package {
               name
               ecosystem
             }
             vulnerableVersionRange
             firstPatchedVersion {
               identifier
             }
             advisory {
               cvss {
                 vectorString
                 score
               }
               cwes(first:100) {
                 edges {
                   node {
                     cweId
                     name
                   }
                 }
               }
               id
               ghsaId
               severity
               summary
               permalink
               description
             }

           }
         }
       }
     }
    }
    GRAPHQL
  end

end
