def problem1(ar,k)
  ar.each_with_index.any? do |a,i|
    (ar[0...i]+ar[i+1..-1]).index(k-a)
  end
end

def problem2(ar)
  ar.map.each_with_index do |a,i|
    (ar[0...i].reduce(1,:*))*(ar[i+1..-1].reduce(1,:*))
  end
end