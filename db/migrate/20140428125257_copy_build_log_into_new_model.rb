class CopyBuildLogIntoNewModel < ActiveRecord::Migration
  class Build < ActiveRecord::Base
    has_many :process, class_name: BuildProcess.name

    serialize :log
  end
  class BuildProcess < ActiveRecord::Base
    belongs_to :build
    has_many :logs, foreign_key: :process_id, class_name: BuildLog.name
  end
  class BuildLog < ActiveRecord::Base
    belongs_to :process, class_name: BuildProcess.name
  end

  def up
    say_with_time 'Copying the logs into new model' do
      builds = Build.all
      total = builds.size
      progress = ProgressBar.create(title: "Builds", total: total, format: '%a |%b>>%i| %p%% %t')
      builds.find_each do |build|
        log = build.log
        process = BuildProcess.new(name: "Prepare")
        log.each do |log|
          if log.is_a?(Symbol)
            process = BuildProcess.new(number: process.number + 1)
            process.build = build
            process.name = log.to_s.camelize
            process.save
          else
            body = BuildLog.new(number: process.logs.size)
            body.process = process
            body.command = log[:command]
            body.log = log[:output]
            body.save
          end
        end
        progress.increment
      end
      total
    end
  end

  def down
    BuildProcess.delete_all
    BuildLog.delete_all
  end
end
