rspec_options = {
  cmd: 'bundle exec rspec --format documentation',
  failed_mode: :focus
}

guard :rspec, rspec_options do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    ["app/models/#{m[1]}.rb", "spec/models/#{m[1]}_spec.rb"]
  end

  # Ruby files
  dsl.watch_spec_files_for(%r{^app/(.+)\.rb$})
end
