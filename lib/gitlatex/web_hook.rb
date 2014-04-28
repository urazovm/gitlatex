class Gitlatex::WebHook
  attr_reader :kind, :body
  
  def initialize(params)
    target = (params[:object_kind] || 'push').classify
    @kind = "Gitlatex::WebHook::#{target}".safe_constantize
    @body = Gitlab::ObjectifiedHash.new params
  end

  def perform!
    if @kind and @kind.method_defined?(:perform)
      @kind.new.perform @body
    end
  end
end

Dir[File.expand_path('../web_hook/*.rb', __FILE__)].each{|f| require f}
