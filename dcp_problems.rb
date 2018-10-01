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

# problem3
class Node
  attr_accessor :val, :left, :right
  def initialize(val,left=nil,right=nil)
    @val = val
    @left = left
    @right = right
  end
end

def deserialize(s)
  eval(s)
end

def serialize(node)
  return 'nil' if node.nil?
  ret = "Node.new('#{node.val}'"
  ret += ", #{serialize(node.left)}" if node.left
  ret += ", #{serialize(node.right)}" if node.right
  return ret+')'
end

def problem4(ar)
  (1..ar.size+1).each do |a|
    return a if ar.index(a).nil?
  end
end
