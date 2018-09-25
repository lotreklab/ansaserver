require 'rake/testtask'


Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_ansa.rb'
end

desc "Run tests"
task :default => :test
