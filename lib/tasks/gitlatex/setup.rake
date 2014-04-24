namespace :gitlatex do
  desc "Setup Gitlatex for production application"
  task :setup => ["db:setup", "gitlatex:manager:setup", "gitlatex:sync:all"]

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

  namespace :sync do
    desc "Synchronize all information of Gitlab"
    task :all => ["gitlatex:sync:user", "gitlatex:sync:project", "gitlatex:sync:user_project", "gitlatex:sync:hook"]

    desc "Synchronize user information of Gitlab"
    task :user => :environment do
      Gitlatex::Gitlab::Sync.assure_users
    end

    desc "Synchronize project information of Gitlab"
    task :project => :environment do
      Gitlatex::Gitlab::Sync.assure_projects
    end

    desc "Synchronize relations between user and project of Gitlab"
    task :user_project => :environment do
      Gitlatex::Gitlab::Sync.assure_user_projects
    end

    desc "Setup hook for synchronization"
    task :hook => :environment do
      Gitlatex::Gitlab::Sync.assure_hook
    end
  end
end
