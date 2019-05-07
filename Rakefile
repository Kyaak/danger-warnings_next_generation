require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:specs)

task default: :specs

task :spec do
  Rake::Task['specs'].invoke
  Rake::Task['rubocop'].invoke
  Rake::Task['spec_docs'].invoke
end

desc 'Run RuboCop on the lib/specs directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = %w(lib/**/*.rb spec/**/*.rb)
  task.fail_on_error = false
  task.formatters = %w(simple json)
  task.options = %w(--out rubocop-result.json)
end

desc 'Ensure that the plugin passes `danger plugins lint`'
task :spec_docs do
  sh 'bundle exec danger plugins lint'
end
