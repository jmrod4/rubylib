# extend Float class
class Float
  # Return a float with specified +significant_digits+ and the rest
  # rounded or zeroed
  # (derived from a 2011 Stack Overflow answer by Victor Deryagin)
  def signif(significant_digits)
    Float(sprintf("%.#{significant_digits}g", self))
  end
end
