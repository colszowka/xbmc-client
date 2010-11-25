require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "xbmc-client"
    gem.summary = %Q{A simple API client for the XBMC JSON-RPC API}
    gem.description = %Q{A simple API client for the XBMC JSON-RPC API}
    gem.email = "christoph at olszowka de"
    gem.homepage = "http://github.com/colszowka/xbmc-client"
    
    gem.add_dependency 'httparty', ">= 0.6.0"
    gem.add_dependency 'json', ">= 1.4.5"
    gem.add_dependency 'activesupport', ">= 3.0.0"
    gem.add_dependency 'i18n'
    
    gem.authors = ["Christoph Olszowka"]
    gem.add_development_dependency "shoulda", "2.10.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "xbmc-client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
