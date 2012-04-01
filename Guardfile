# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^scrolls/(.+)\.rb$})     { |m| "spec/rails_wizard/scrolls/sanity_spec.rb" }
  watch(%r{^lib/rails_wizard/(.+)\.rb$})     { |m| "spec/rails_wizard/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

