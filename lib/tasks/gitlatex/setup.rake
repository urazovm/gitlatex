namespace :gitlatex do
  desc "Gitlatex Setup production application"
  task setup: :environment do
    setup_db
  end

  def setup_db
    Rake::Task["db:setup"].invoke
    Rake::Task["db:seed_fu"].invoke
  end
end
