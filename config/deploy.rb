set :application, "dokoiku"
set :repository,  "http://dokoiku.googlecode.com/svn/trunk/"

set :user, "dokoiku"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/#{user}/capistrano/#{application}"

set :mongrel_config_path, "/home/#{user}/capistrano/#{application}/config/mongrel_cluster.yml"
set :config_dir, "/home/#{user}/capistrano/#{application}/config"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:

set :scm, :subversion

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true

after "deploy:update" do
  run "cp -fr #{config_dir}/* #{release_path}/config/." 
end

namespace :deploy do
  desc "START mongrels"
  task :start, :roles=>:app do
    run "cd #{current_path} && mongrel_rails cluster::start -C #{mongrel_config_path}"
  end

  desc "STOP mongrels"
  task :stop, :roles=>:app do
    run "cd #{current_path} && mongrel_rails cluster::stop -C #{mongrel_config_path}"
  end

  desc "RESTART mongrels"
  task :restart, :roles=>:app do
    stop
    start
  end

end