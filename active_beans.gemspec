$:.push File.expand_path("../lib", __FILE__)
require "active_beans/version"

Gem::Specification.new do |s|
  s.name        = "active_beans"
  s.version     = "0.0.1"
  s.authors     = ["Sergiy Volkov"]
  s.email       = ["sv@mooby.org"]
  s.homepage    = ""
  s.summary     = %q{ActiveBeans - Distributed Task Queue for Ruby applications}
  s.description = %q{Distributed Task Queue for Ruby applications }
  s.homepage    = "https://github.com/woolf/active_beans"

  s.rubyforge_project = "active_beans"

  s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency "beanstalk-client"
  s.add_dependency "eventmachine"
  s.add_dependency "em-beanstalk"
  s.add_dependency "json"
end
