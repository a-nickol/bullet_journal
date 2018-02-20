# frozen_string_literal: true

group :red_green_refactor, halt_on_fail: true do
  guard :minitest do
    watch(%r{^test/(.*)\/?test_(.*)\.rb$})
    watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
    watch(%r{^test/test_helper\.rb$})      { 'test' }
  end

  guard :rubocop, cli: '--cache false' do
    watch(/.+\.rb$/)
    watch(/.+\.gemspec$/)
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
