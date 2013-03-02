require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:test) do |config| 
   config.rspec_opts = "-I . --format doc --color"
end

task :default => [:test]
