# Define roles, user and IP address of deployment server
role :app, %w{deploy@[IP]}
set :stage, :staging

server '[IP]', user: 'deploy', port:'[PORT]', roles: %w{app}

set :branch, "dev"
set :deploy_to, "/var/www/staging.domain.com/htdocs/"

set :log_level, :debug

set :db_host, "127.0.0.1"
set :db_name, "[db_staging_name]"
set :db_user, "[db_user]"
set :db_password, "[db_password]"