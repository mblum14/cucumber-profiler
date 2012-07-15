require 'cucumber/formatter/profiler'
require 'cucumber/formatter/base'
require 'cucumber/ast/feature_element'

# Extend Cucumber's builtin formats, so that this
# formatter can be used with --format fuubar
require 'cucumber/cli/options'

Cucumber::Cli::Options::BUILTIN_FORMATS["profiler"] = [
  "Cucumber::Formatter::Profiler",
  "A formatter for benchmarking your features"
]

