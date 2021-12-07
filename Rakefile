require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'build docker image'
task :build_docker do
  require './lib/dependagrab.rb'
  system("docker build --tag ddazza/dependagrab:#{Dependagrab::VERSION} .")
  system("docker tag ddazza/dependagrab:latest ddazza/dependagrab:#{Dependagrab::VERSION}")

  puts
  puts  "$ docker push ddazza/dependagrab:#{Dependagrab::VERSION}"
  puts  "$ docker push ddazza/dependagrab:latest"
end
