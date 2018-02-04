# frozen_string_literal: tru

Gem::Specification.new do |s|
  s.name     = 'bullet_journal'
  s.version  = '0.0.1'
  s.licenses = ['MIT']
  s.summary  = 'Tool for creating printable bullet journal pages.'
  s.files    = ['lib/example.rb']
  s.author   = 'HansPeterIngo'

  s.add_runtime_dependency 'holidays'
  s.add_runtime_dependency 'prawn'
  s.add_runtime_dependency 'thor'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'guard-rubocop'
end
