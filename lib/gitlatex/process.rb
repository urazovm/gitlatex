require 'yaml'
require 'open3'
require 'fileutils'
class Gitlatex::Process
  attr_accessor :branch, :name, :url, :tmp_dir, :output_dir, :log, :error, :files

  def initialize(build)
    self.branch = build.branch
    self.name = build.repository_name
    self.url = build.repository_url
    self.log = []
    self.tmp_dir = File.join(Settings.build.tmp_dir, build.unique_name)
    self.output_dir = build.unique_name
    self.files = []
    FileUtils.mkdir_p tmp_dir
  end

  def command_with_log(*args)
    cmd = args.map(&:to_s).join(' ')
    Open3.popen2e cmd do |stdin, stdout, thr|
      stdin.close
      self.log << Gitlatex::Log.new(cmd, stdout.read)
      raise "Command error: #{cmd} failed" unless thr.value.success?
    end
  end

  def run(config)
    config.before_script.each do |script|
      command_with_log script
    end
    config.process.each do |process|
      self.log << process
      if config.commands[process].is_a?(Array)
        config.commands[process].each do |script|
          command_with_log script
        end
      else
        command_with_log config.commands[process]
      end
    end
    config.after_script.each do |script|
      command_with_log script
    end
  end

  def perform
    begin
      Dir.chdir self.tmp_dir do
        command_with_log :git, :clone, "-b", branch, "--depth", 1, "--single-branch", "--", url, name
        Dir.chdir self.name do
          config = load_config
          config = Gitlatex::Config.parse config
          
          run config

          check_files config
          move_files config
        end
      end
    rescue
      self.error = $!
    end
    self
  end

  def check_files(config)
    config.output_files.each do |file|
      raise "File not build: #{file} dose not output" unless File.exist?(file)
    end
  end

  def move_files(config)
    FileUtils.mkdir_p Rails.root.join("public", "files", output_dir)
    config.output_files.each do |file|
      to = Rails.root.join("public", "files", self.output_dir, file)
      FileUtils.mv file, to
      self.files << {name: file, path: File.join(self.output_dir, file)}
    end
  end

  def load_config
    begin
      YAML.load_file('.gitlatex.yml')
    rescue SyntaxError
      raise "Syntax error: please check '.gitlatex.yml' file"
    rescue
      raise "File not found: '.gitlatex.yml' is not exists"
    end
  end

  def close
    FileUtils.rm_rf(tmp_dir)
    self
  end

  class << self
    def perform(build)
      self.new(build).perform.close
    end
  end
end
