# Define roles, user and IP address of deployment server
role :app, %w{deploy@[IP]}
set :stage, :production

server '[IP]', user: 'deploy', roles: %w{app}

set :branch, "master"
set :deploy_to, "/var/www/domain.com/htdocs/"

set :db_host, "127.0.0.1"
set :db_name, "[db_name]"
set :db_user, "[db_user]"
set :db_password, "[db_password]"