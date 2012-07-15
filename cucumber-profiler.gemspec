Gem::Specification.new do |s|
  s.name        = "cucumber-profiler"
  s.version     = "0.0.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Blumberg"]
  s.email       = ["mblum14@gmail.com"]
  s.homepage    = "https://github.com/mblum14/cucumber-profiler"
  s.summary     = %q{A way to profile the performance of your cucumber features}
  s.description = %q{A way to profile the performance of your cucumber features}

  s.rubyforge_project = "cucumber-profiler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('cucumber', ["~> 1.2.1"])
end
