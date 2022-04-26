# SonarCloud MetricKit

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-sonarcloud_metric_kit)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-sonarcloud_metric_kit`, add it to your project by running:

```bash
fastlane add_plugin sonarcloud_metric_kit
```

## About sonarcloud_metric_kit

With this fastlane plugin, you can access most of the metrics collected by SonarCloud

| Option | Description | Default |
| ------- |------------ | ------- |
| project_key | Project key on SonarCloud | |
| sonar_token | [API token for private repositories](https://sonarcloud.io/account/security) | |
| period | Analysis period to use for new metrics | 0 |
| quality_gate | Should quality gate be parsed? | false |

## Usage

```ruby
metrics = sonarcloud_metric_kit(
  project_key: 'GetStream_stream-chat-swift',
  quality_gate: true
)
UI.message "Total coverage: #{metrics[:coverage]}"
```

## Start working on this plugin

First of all, install any dependencies

```bash
bundle install
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```bash
bundle exec rake
```

To automatically fix many of the styling issues, use

```bash
bundle exec rubocop -a
```

## Release a new version

To release the plugin, bump the [version](https://github.com/GetStream/fastlane-plugin-sonarcloud_metric_kit/blob/main/lib/fastlane/plugin/sonarcloud_metric_kit/version.rb) and run

```bash
bundle exec fastlane release
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
