$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

# Maintain your gem's version:
require "paid/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'paid'
  s.version     = Paid::VERSION
  s.authors     = ['Ryan Jackson']
  s.email       = ['ryan@paidapi.com']
  s.homepage    = 'https://docs.paidapi.com'
  s.summary     = 'Ruby bindings for Paid API'
  s.description = 'Paid is the programmatic way to manage payments.  See https://paidapi.com for details.'
  s.license     = 'MIT'

  s.add_dependency('rest-client', '~> 1.4')
  s.add_dependency('mime-types', '>= 1.25', '< 3.0')
  s.add_dependency('json', '~> 1.8.1')

  s.add_development_dependency('mocha', '~> 0.13.2')
  s.add_development_dependency('shoulda', '~> 3.4.0')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
