class Gitlatex::WebHook::Push
  def perform(body)
    hash = {
      from: body.before,
      target: body.after,
      branch: body.ref.split(/\//)[-1],
      user_id: body.user_id,
      project_id: body.project_id,
    }

    build = Build.new hash
    if build.save
      BuildWorker.perform_async build.id
    end
  end
end
