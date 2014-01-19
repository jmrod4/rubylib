# encoding: UTF-8

class Float
  # Return a float "rounded" to the specified significant_digits
  def signif(significant_digits)
    Float("%.#{significant_digits}g" % self)
  end

  # Return an string with a representation of the +value+
  # followed by a unit prefix
  # +precision+ expresed in 1/parts
  def eng_notation(precision = 1.0 / 500)
    #handle special case
    return '0 ' if zero?

    # normal is normalized representation with only one digit real 
    # part (left to the decimal point), and power is an integer such as: 
    #   value = normal * 10**power
    # and to find normal:
    #   normal = value * 10**(-power)
    power = Math.log10(self).floor
    normal = self * 10**(-power)
    while (normal - normal.round).abs / normal > precision
      # now pass digits to the real part of the number until
      # we get the required precision with only the rounded number
      normal *= 10
      # adjust power so still: value = normal * 10**power
      power -= 1
    end
    # strip the fractionary part
    normal = normal.round
    
    # avoid too long numbers like: '23450 M' and prefer '23.45 G'
    while normal.to_i.to_s.size > 2
      normal /= 10.0
      power += 1
    end

    case
    when power < -9
      normal *= 10**(12 + power)
      power = -12
      prefix = 'p'
    when power < -6
      normal *= 10**(9 + power)
      power = -9
      prefix = 'n'
    when power < -3
      normal *= 10**(6 + power)
      power = -6
      prefix = 'μ'
    when power < 0
      normal *= 10**(3 + power)
      power = -3
      prefix = 'm'
    when power < 3
      prefix = ''
      normal *= 10**power
      power = 0
    when power < 6
      prefix = 'k'
      normal *= 10**(power - 3)
      power = 3
    when power < 9
      prefix = 'M'
      normal *= 10**(power - 6)
      power = 6
    when power < 12
      prefix = 'G'
      normal *= 10**(power - 9)
      power = 9
    else
      prefix = 'T'
      normal *= 10**(power - 12)
      power = 12
    end

    sprintf('%g %s', normal, prefix)
  end
end


# prec = 1.0/500
# for i in (-12..12)
  # val = 2.3456789012
  # val *= 10**i
  # puts Float(val).eng_notation(prec)
# end
