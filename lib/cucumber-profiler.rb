require 'cucumber/formatter/profiler'

# Extend Cucumber's builtin formats, so that this
# formatter can be used with --format fuubar
require 'cucumber/cli/options'

Cucumber::Cli::Options::BUILTIN_FORMATS["Profiler"] = [
  "Cucumber::Formatter::Profiler",
  "A formatter for benchmarking your features"
]

