# frozen_string_literal: tru

Gem::Specification.new do |s|
  s.name        = 'Bullet Journal'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = 'Tool for creating printable bullet journal pages.'
  s.files       = ['lib/example.rb']

  s.add_runtime_dependency 'holidays'
  s.add_runtime_dependency 'prawn'
  s.add_runtime_dependency 'thor'

  s.add_development_dependency 'rubocop'
end
