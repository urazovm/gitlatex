module Gitlatex::Gitlab::Sync
  include Gitlatex::Assure

  before do
    Gitlatex::Gitlab::Manager.accessable!
  end

  assure :users do
    User.update_all(synced: false)
    request :users, per_page: 100 do |response|
      while response.is_a?(Array)
        puts "Sync #{response.length} users".emph
        response.each do |user|
          UserWorker.new.perform user.id
        end
        response = response.has_next? ? response.retrive_next : nil
      end
    end
    User.where(synced: false).destroy_all
  end

  assure :projects do
    Project.update_all(synced: false)
    request :all_projects, per_page: 100 do |response|
      while response.is_a?(Array)
        puts "Sync #{response.length} projects".emph
        response.each do |project|
          ProjectWorker.new.perform project.id
        end
        response = response.has_next? ? response.retrive_next : nil
      end      
    end
    Project.where(synced: false).destroy_all
  end

  assure :user_projects do
    UserProject.update_all(synced: false)
    request :all_projects, per_page: 100 do |response|
      while response.is_a?(Array)
        puts "#{response.length} projects".emph
        response.each do |project|
          members = Gitlab.team_members(project.id)
          while members.is_a?(Array)
            puts "  has #{members.length} members".emph
            members.each do |member|
              UserProjectWorker.new.perform project.id, member.email
            end
            members = members.has_next? ? members.retrive_next : nil
          end
        end
        response = response.has_next? ? response.retrive_next : nil
      end      
    end
    puts UserProject.where(synced: false).map(&:synced)
    UserProject.where(synced: false).destroy_all
  end

  assure :hook do
    request :hooks do |response|
      def check_single_hook(response)
        response.length <= 1
      end
      def check_own_hook(response)
        return false if response.length < 1
        url = Gitlatex::Routes.hook_url(only_path: false)
        response.first.url == url
      end
      
      condition(:check_single_hook, response) do
        until response.length <= 1
          Gitlab.delete_hook response.last.id
          response.pop
        end
      end
      condition(:check_own_hook, response) do
        Gitlab.delete_hook response.first.id if response.length > 0
        url = Gitlatex::Routes.hook_url(only_path: false)
        Gitlab.create_hook(url)
      end
    end
  end
end
