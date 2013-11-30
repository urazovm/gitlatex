class Gitlatex::Config
  attr_accessor :variables, :commands, :process, :output_files, :before_script, :after_script

  def parse(config)
    symbolize_keys! config
    [:variables, :commands, :process, :output_files, :before_script, :after_script].each do |sym|
      self.send("#{sym.to_s}=", config[sym])
    end
    expand_variables
    process.map!(&:to_sym)
  end
  def symbolize_keys!(config)
    config.symbolize_keys!.each do |key,value|
      if value.is_a?(Hash)
        symbolize_keys!(value)
      elsif value.is_a?(Array)
        value.map!{|v| v.is_a?(Hash) ? symbolize_keys!(v) : v}
      end
    end
  end
  private :symbolize_keys!
  def expand_variables
    commands.keys.each do |key|
      commands[key] = expand_string commands[key]
    end
    output_files.map! do |value|
      expand_string value
    end
    before_script.map! do |value|
      expand_string value
    end
    after_script.map! do |value|
      expand_string value
    end
  end
  private :expand_variables
  def expand_string(str)
    variables.inject str do |str, kv|
      key, value = kv
      str.gsub(/\$#{key.to_s}/, value)
    end
  end
  private :expand_string
  
  class << self
    def parse(config)
      this = self.new
      this.parse config
      this
    end
  end
end
