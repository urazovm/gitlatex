class TrueClass
  def emph
    "\e[1;37;44m#{self}\e[0m"
  end
end
class FalseClass
  def emph
    "\e[1;37;41m#{self}\e[0m"
  end
end
