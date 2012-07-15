require 'cucumber/formatter/profiler'
require 'cucumber/ast/benchmark'
require 'cucumber/cli/options'

Cucumber::Cli::Options::BUILTIN_FORMATS["profiler"] => [
  "Cucumber::Formatter::Profiler",
  "A formatter for benchmarking your features"
]

