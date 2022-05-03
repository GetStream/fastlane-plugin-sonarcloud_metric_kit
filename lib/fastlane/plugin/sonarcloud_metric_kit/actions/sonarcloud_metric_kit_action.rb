require 'fastlane/action'

module Fastlane
  module Actions
    class SonarcloudMetricKitAction < Action
      def self.run((params))
        collect_metrics(params)
      end

      def self.api_url
        'https://sonarcloud.io/api'
      end

      def self.collect_metrics(params)
        metrics = {}
        measures = get_measures(params)
        metric_keys.each do |key|
          metric = measures.find { |m| m['metric'] == key.to_s }
          metrics[key.to_sym] =
            if metric['value']
              metric['value']
            elsif params[:period] && metric['periods'].size > params[:period]
              metric['periods'][params[:period]]['value']
            else
              metric['periods']
            end
        end
        return metrics unless params[:quality_gate]

        quality_gate = get_quality_gate(params)
        metrics[:quality_gate] = quality_gate
        if params[:period] && quality_gate['periods'].size > params[:period]
          metrics[:period_value] = quality_gate['periods'][params[:period]]['parameter']
        end
        metrics
      end

      def self.get_measures(params)
        queries = ["componentKey=#{params[:project_key]}", "metricKeys=#{metric_keys.join(',')}"]
        queries << "branch=#{params[:branch]}" if params[:branch]
        url = URI("#{api_url}/measures/component?#{queries.join('&')}")
        response = json_parse(request(url, token: params[:sonar_token]).read_body)
        UI.user_error!(response) unless response['component']
        response['component']['measures']
      end

      def self.get_quality_gate(params)
        queries = ["projectKey=#{params[:project_key]}"]
        queries << "branch=#{params[:branch]}" if params[:branch]
        url = URI("#{api_url}/qualitygates/project_status?#{queries.join('&')}")
        response = json_parse(request(url, token: params[:sonar_token]).read_body)
        UI.user_error!(response) unless response['projectStatus']
        response['projectStatus']
      end

      def self.request(url, token:)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(url)
        request['authorization'] = "Basic #{token}" if token
        request['content-type'] = 'application/json'
        http.request(request)
      end

      def self.metric_keys
        %w[
          alert_status
          new_bugs
          new_reliability_rating
          new_reliability_remediation_effort
          bugs
          reliability_rating
          reliability_remediation_effort
          new_vulnerabilities
          new_security_rating
          new_security_remediation_effort
          vulnerabilities
          security_rating
          security_remediation_effort
          new_security_hotspots
          new_security_review_rating
          new_security_hotspots_reviewed
          security_hotspots
          security_review_rating
          security_hotspots_reviewed
          new_code_smells
          new_technical_debt
          new_sqale_debt_ratio
          new_maintainability_rating
          code_smells
          sqale_index
          sqale_debt_ratio
          sqale_rating
          effort_to_reach_maintainability_rating_a
          new_coverage
          new_lines_to_cover
          new_uncovered_lines
          new_line_coverage
          new_conditions_to_cover
          new_uncovered_conditions
          coverage
          lines_to_cover
          uncovered_lines
          line_coverage
          new_duplicated_lines_density
          new_duplicated_lines
          new_duplicated_blocks
          duplicated_lines_density
          duplicated_lines
          duplicated_blocks
          duplicated_files
          new_lines
          ncloc
          lines
          statements
          functions
          classes
          files
          comment_lines
          comment_lines_density
          complexity
          cognitive_complexity
          new_violations
          violations
          open_issues
          reopened_issues
          confirmed_issues
          false_positive_issues
          wont_fix_issues
        ]
      end

      def self.json_parse(response)
        JSON.parse(response)
      rescue JSON::ParserError
        UI.user_error!('Cannot parse the result from SonarCloud. Double check the project key (and token if required)')
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Collects metrics from SonarCloud'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :project_key,
            description: 'Project key on SonarCloud',
            is_string: true,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :sonar_token,
            description: 'API token for private repositories (https://sonarcloud.io/account/security)',
            is_string: true,
            optional: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :period,
            description: 'Analysis period to use for new metrics, collects all if nil',
            is_string: false,
            optional: true,
            default_value: 0
          ),
          FastlaneCore::ConfigItem.new(
            key: :quality_gate,
            description: 'Should quality gate be parsed?',
            is_string: false,
            optional: true,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :branch,
            description: 'Git branch to use for collecting metrics',
            is_string: true,
            optional: true
          )
        ]
      end

      def self.authors
        ['alteral']
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
