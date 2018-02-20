def ppp(x)
  if x.class == Array
    puts_array(x)
  else
    puts x
  end
end

def puts_array(x)
  need_new_line = false
  x.each do |e|
    if e.class == Array
      puts e.join(', ')
    else
      print e.to_s + ', '
      need_new_line = true
    end
  end
  puts if need_new_line
end
