def chronal_conversion
  history = []
  r2, r3 = [0, 0]
  
  loop do
    r3 = (((r3 + (r2 & 255)) & 16777215) * 65899) & 16777215

    if 256 > r2
      return history[-1] if history.include?(r3)
      history << r3
      r2 = r3 | 65536
      r3 = 832312
      next
    end

    r2 = r2 / 256
  end
end

puts chronal_conversion
