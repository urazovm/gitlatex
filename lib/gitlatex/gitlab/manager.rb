require 'io/console'
require 'gitlatex/assure'

module Gitlatex::Gitlab::Manager
  include Gitlatex::Assure

  def self.create!
    email = Settings.gitlab_account.email
    password = Settings.gitlab_account.password
    options = {
      name: Settings.gitlab_account.username,
      username: Settings.gitlab_account.username,
      bio: "Gitlatex manager",
    }
    "Create gitlatex manager user".puts_with_rescue! do
      Gitlab.create_user email, password, options
    end
  end

  assure :user do
    request :gitlatex do |response|
      error Gitlab::Error::Unauthorized do
        while Gitlab.private_token.nil?
          print "Please input admin login name: "
          login = STDIN.gets.chomp
          print "Please input admin password: "
          password = STDIN.noecho(&:gets).chomp
          puts ''
          begin
            Gitlab.private_token = Gitlab.session(login, password).private_token
          rescue => e
            puts "Failed to login"
          end
        end
        Gitlatex::Gitlab::Manager.create!
      end

      success do
        Gitlab.private_token = response.private_token
      end
    end
    
    request :user do |response|
      def check_user(response)
        return false unless response.email == Settings.gitlab_account.email
        return false unless response.name == Settings.gitlab_account.username
        return false unless response.username == Settings.gitlab_account.username
        return false unless response.email == Settings.gitlab_account.email
        return false unless response.is_admin
        return true
      end
      error Gitlab::Error::Unauthorized do
        raise response
      end
      condition(:check_user, response) do
        puts "Please make the gitlatex user admin in gitlab admin panel.".emph
        puts "Suggest you to recreate gitlatex manager user if you face unknown error".emph
        puts "Enter to continue...".emph
        STDIN.gets
      end
    end
  end

  assure :user_key do
    request :ssh_keys do |response|
      def check_single_key(response)
        response.length <= 1
      end
      def check_own_key(response)
        return false if response.length < 1
        key = SSHKey.new File.read("#{Dir.home}/.ssh/id_rsa")
        key.ssh_public_key == response.first.key
      end
      
      condition(:check_single_key, response) do
        until response.length <= 1
          Gitlab.delete_ssh_key response.last.id
          response.pop
        end
      end
      condition(:check_own_key, response) do
        Gitlab.delete_ssh_key response.first.id if response.length > 0
        key = SSHKey.new File.read("#{Dir.home}/.ssh/id_rsa")
        Gitlab.create_ssh_key('Gitlatex', key.ssh_public_key)
      end
    end
  end

  assure :ssh_key do
    file "#{Dir.home}/.ssh/id_rsa" do |path|
      def create_key(path)
        key = SSHKey.generate
        File.open(path, 'w'){|f| f.puts(key.private_key) }
        File.open("#{path}.pub", 'w'){|f| f.puts(key.ssh_public_key) }
      end

      exists? { create_key path }
      permission? 0600 
    end
    file "#{Dir.home}/.ssh/id_rsa.pub" do |path|
      def create_public_key(path)
        key = SSHKey.new File.read("#{Dir.home}/.ssh/id_rsa")
        File.open(path, 'w'){|f| f.puts(key.ssh_public_key) }
      end
      def check_key_pair(path)
        key = SSHKey.new File.read("#{Dir.home}/.ssh/id_rsa")
        key.ssh_public_key.strip == File.open(path).read.strip
      end
      
      exists? { create_public_key path }
      permission? 0644
      condition(:check_key_pair, path){ create_public_key path }
    end
  end
end
