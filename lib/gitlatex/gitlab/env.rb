module Gitlatex::Gitlab::Env
  include Gitlatex::Assure

  assure :directory do
    directory Rails.root.join('log') do |path|
      exists?
      permission? 0775
    end
    directory Rails.root.join('tmp') do |path|
      exists?
      permission? 0775
    end
    directory Rails.root.join('files') do |path|
      exists?
      permission? 0775
    end
  end
end
