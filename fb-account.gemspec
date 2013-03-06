# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fb_account/version'

Gem::Specification.new do |gem|
  gem.name          = "fb-account"
  gem.version       = FbAccount::VERSION
  gem.authors       = ["superp"]
  gem.email         = ["superp1987@gmail.com"]
  gem.description   = %q{Facebook rails helper for accounts}
  gem.summary       = %q{Useful for facebook tabs and canvases}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  #gem.add_runtime_dependency("rails", "~> 3.2.0")
  gem.add_runtime_dependency("fb_graph")
end
