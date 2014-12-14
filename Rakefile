require "bundler/gem_tasks"
require "rackdis"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

task :routes do
  puts Rackdis::API::routes
end

task :console do
  begin
    # use Pry if it exists
    require 'pry'
    require 'rackdis'
    Pry.start
  rescue LoadError
    require 'irb'
    require 'irb/completion'
    require 'rackdis'
    ARGV.clear
    IRB.start
  end
end

task :c => :console
