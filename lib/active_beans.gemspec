# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_beans/version"

Gem::Specification.new do |s|
  s.name        = "active_beans"
  s.version     = ActiveBeans::VERSION
  s.authors     = ["Sergiy Volkov"]
  s.email       = ["sv@mooby.org"]
  s.homepage    = ""
  s.summary     = %q{TODO: ActiveBeans - Distributed Task Queue for Ruby applications}
  s.description = %q{TODO: TODO}
  s.version    = ActiveBeans::VERSION

  #s.rubyforge_project = "active_beans"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {lib/test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
