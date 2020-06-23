# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name         = 'crystalball_prophecy'
  s.version      = '0.1.0'
  s.authors      = ['Jaimerson Araújo <jaimersonaraujo@gmail.com>']
  s.summary      = 'A crystalball addon to read and write file dependencies more efficiently'
  s.files        = Dir['{lib/**/*,[A-Z]*}']

  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.add_dependency 'helix_runtime', '~> 0.7.5'
  s.add_development_dependency 'rspec', '~> 3.9.0'
end
