describe Fastlane do
  describe Fastlane::FastFile do
    let(:project_key) { 'GetStream_stream-chat-swift' }

    describe 'SonarCloud MetricKit Action' do
      it 'ensures that quality gate can be accessed' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            quality_gate: true
          )
        end").runner.execute(:test)
        expect(result[:quality_gate]).not_to be_nil
      end

      it 'ensures that quality gate period can be accessed' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            quality_gate: true
          )
        end").runner.execute(:test)
        expect(result[:period_value]).not_to be_nil
      end

      it 'ensures that metrics can be accessed' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}'
          )
        end").runner.execute(:test)

        Fastlane::Actions::SonarcloudMetricKitAction.metric_keys.each do |key|
          expect(result[key.to_sym]).not_to be_nil
        end
      end

      it 'ensures that metrics can be accessed when period is nil' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            period: nil,
            quality_gate: true
          )
        end").runner.execute(:test)
        expect(result[:quality_gate]).not_to be_nil
      end

      it 'ensures that metrics can be accessed when period is wrong' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            period: 33,
            quality_gate: true
          )
        end").runner.execute(:test)
        expect(result[:quality_gate]).not_to be_nil
      end

      it 'ensures that metrics can be accessed when branch is provided' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            branch: 'develop'
          )
        end").runner.execute(:test)

        Fastlane::Actions::SonarcloudMetricKitAction.metric_keys.each do |key|
          expect(result[key.to_sym]).not_to be_nil
        end
      end

      it 'ensures that quality gate can be accessed when branch is provided' do
        result = described_class.new.parse("lane :test do
          sonarcloud_metric_kit(
            project_key: '#{project_key}',
            quality_gate: true,
            branch: 'develop'
          )
        end").runner.execute(:test)
        expect(result[:quality_gate]).not_to be_nil
      end

      it 'ensures that metrics can be accessed when branch is wrong' do
        branch = 'non-existent-branch'
        error_message = "{\"errors\"=>[{\"msg\"=>\"Component '#{project_key}' on branch '#{branch}' not found\"}]}"
        expect do
          described_class.new.parse("lane :test do
            sonarcloud_metric_kit(
              project_key: '#{project_key}',
              quality_gate: true,
              branch: '#{branch}'
            )
          end").runner.execute(:test)
        end.to raise_error(error_message)
      end
    end
  end
end
