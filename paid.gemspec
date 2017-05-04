$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'paid/version'

spec = Gem::Specification.new do |s|
  s.name = 'paid'
  s.summary = 'Ruby bindings for Paid API'
  s.description = 'Paid is the programmatic way to manage payments.  See https://paidlabs.com for details.'
  s.homepage = 'http://docs.paidlabs.com'
  s.authors = ['Jon Calhoun', 'Ryan Jackson']
  s.email = ['jon@paidlabs.com', 'ryan@paidlabs.com']
  s.version = Paid::VERSION
  s.license = 'MIT'

  s.add_dependency('rest-client', '~> 2.0.0')
  s.add_dependency('mime-types', '>= 1.25', '<= 3.1')
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

