desc "Run Continuous Integration Suite (tests, coverage, docs)"
task :ci do
  
  require 'jettywrapper'
  jetty_params = Jettywrapper.load_config.merge({
    :jetty_home => File.expand_path(File.dirname(__FILE__) + '/../../jetty'),
    :jetty_port => 8983,
    :startup_wait => 50, 
    #:java_opts => "-DGEOSERVER_DATA_DIR="+File.expand_path(File.dirname(__FILE__) + '/../../jetty/data_dir')+ " -Djava.awt.headless=true -DSTOP.PORT=8079 -DSTOP.KEY=geoserver" 
    :java_opts => "-DGEOSERVER_DATA_DIR="+File.expand_path(File.dirname(__FILE__) + '/../../jetty/data_dir')
  })

  error = nil
  error = Jettywrapper.wrap(jetty_params) do
    Rails.env = "test"
    Rake::Task["doc"].invoke
    Rake::Task["simplecov"].invoke
  end
  raise "TEST FAILURES: #{error}" if error
  
end
