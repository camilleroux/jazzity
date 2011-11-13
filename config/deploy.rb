$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

require 'bundler/capistrano'

set :rvm_ruby_string, '1.9.2-p290@jazzity'

## Configuration
set :application, "jazzity"

set :scm, :git
set :repository, "git@github.com:rubiety/#{application}.git"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm_verbose, true
set :ssh_options, {:forward_agent => true}
ssh_options[:port] = 2234

task :staging do
  role :app, "stage.jazzity.com"
  role :web, "stage.jazzity.com"
  role :db,  "stage.jazzity.com", :primary => true
    
  set :rails_env, "staging"
  set :branch, "master"
  set :deploy_to, "/var/www/stage.jazzity.com"
  set :user, "apps"
end

task :production do
  role :app, "jazzity.com"
  role :web, "jazzity.com"
  role :db,  "jazzity.com", :primary => true
    
  set :rails_env, "production"
  set :branch, "master"
  set :deploy_to, "/var/www/jazzity.com"
  set :user, "apps"
end

set :shared_paths, %w(
  config/database.yml
)

after "deploy:symlink", "deploy:shared"
after "deploy:symlink", "deploy:compile_stylesheets"
after "deploy:symlink", "deploy:migrate_database"
after "deploy:symlink", "deploy:generate_friendly_ids"

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :start do
  end
  
  task :stop do
  end
    
  task :shared, :roles => [:app, :web] do
    shared_paths.each do |path|
      run "ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
    end
  end
  
  task :migrate_database, :roles => [:db] do
    run "cd #{release_path} && export RAILS_ENV=#{rails_env} && bundle exec rake db:drop && bundle exec rake db:create && bundle exec rake db:migrate --trace && bundle exec rake db:seed --trace"
  end
  
  task :generate_friendly_ids, :roles => [:db] do
    # %w(chord concept form instrument meter mode musician progression scale tune vehicle voicing).each do |model|
    #   run "cd #{release_path} && export RAILS_ENV=#{rails_env} && bundle exec rake friendly_id:make_slugs MODEL=#{model}; true"
    # end
  end
  
  task :compile_stylesheets, :roles => [:app] do
    # TODO: Need asset pipeline precompile
    # run "cd #{release_path} && export RAILS_ENV=#{rails_env} && bundle exec compass compile"
  end
end
