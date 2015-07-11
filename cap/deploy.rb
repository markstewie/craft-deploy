# config valid only for Capistrano 3.1
lock '3.1.0'

############################################
# Setup project
############################################

set :application, "craft-deploy"
set :repo_url, "git@bitbucket.org:user/repo.git"
set :scm, :git

set :git_strategy, SubmoduleStrategy

############################################
# Local db details
############################################

set :local_db_host, "127.0.0.1"
set :local_db_name, "[db_name]"
set :local_db_user, "homestead"
set :local_db_password, "secret"

# Uncomment if you're using homestead
# set :local_ssh, "ssh vagrant@192.168.10.10"

############################################
# Setup Capistrano
############################################

set :log_level, :info
set :use_sudo, false
set :deploy_as, 'user:group'

set :ssh_options, {
	forward_agent: true,
	paranoid: true
}

set :keep_releases, 3
set :keep_db_backups, 3

############################################
# Run gulp build tasks so we have minified files
############################################

desc "run gulp build tasks"
task :gulp_build do
  run_locally do
    execute "gulp build"
    execute "git add ."
    execute "git commit -m 'Gulp build production assets'"
    execute "git push"
  end
end

before "deploy", :gulp_build

############################################
# Linked files and directories (symlinks)
############################################

namespace :deploy do

	desc "create files for symlinking"
	task :symlink do
		on roles(:app) do
			execute "ln -nfs #{shared_path}/assets #{release_path}/public_html/assets"
			execute "ln -nfs #{shared_path}/craft/app #{release_path}/craft/app"
			execute "ln -nfs #{shared_path}/craft/storage #{release_path}/craft/storage"
		end
	end
	after :finished, :symlink

	desc "Creates robots.txt for non-production envs"
	task :create_robots do
		on roles(:app) do
			if fetch(:stage) != :production then
				io = StringIO.new('User-agent: * Disallow: /')
				upload! io, File.join(release_path, "robots.txt")
				execute :chmod, "644 #{release_path}/robots.txt"
			end
		end
	end

	after :finished, :create_robots
	after :finishing, "deploy:cleanup"
end
