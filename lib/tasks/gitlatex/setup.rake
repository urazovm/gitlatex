namespace :gitlatex do
  desc "Setup Gitlatex for production application"
  task :setup => ["db:setup", "gitlatex:manager:setup"]

  namespace :manager do
    desc "Setup the manager user"
    task :setup => [:ssh_key, :user, :user_key]

    desc "Setup ssh key of gitlatex system in order to access any gitlab repositories"
    task :ssh_key => :environment do
      Gitlatex::Gitlab::Manager.assure_ssh_key
    end

    desc "Setup the manager user of gitlab"
    task :user => :environment do
      Gitlatex::Gitlab::Manager.assure_user
    end

    desc "Setup the deploy key of the manager user"
    task :user_key => [:ssh_key, :user] do
      Gitlatex::Gitlab::Manager.assure_user_key
    end
  end
end
