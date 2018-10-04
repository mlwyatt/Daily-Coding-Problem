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

# problem 3
class Node
  attr_accessor :val, :left, :right
  def initialize(val,left=nil,right=nil)
    @val = val
    @left = left
    @right = right
  end
  def is_unival?
    return true if is_leaf?
    return val == right.val && right.is_unival? if left.nil?
    return val == left.val && left.is_unival? if right.nil?
    return val == right.val && right.val == left.val && left.is_unival? && right.is_unival?
  end
  def count_unival
    return 1 if is_leaf?
    to_add = is_unival? ? 1 : 0
    return to_add+left.count_unival if right.nil?
    return to_add+ right.count_unival if left.nil?
    return to_add+left.count_unival+right.count_unival
  end
  def is_leaf?
    left.nil? && right.nil?
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

# problem 6
class LLNode
  def initialize(val)
    @val = val
    @both = 0
  end
  def val
    @val
  end
  def add_next(n_node)
    @both = @both ^ n_node
  end
  def add_prev(p_node)
    @both = @both ^ p_node
  end
  def next_node(p_node)
    ObjectSpace._id2ref(@both ^ p_node)
  end
  def prev_node(n_node)
    ObjectSpace._id2ref(@both ^ n_node)
  end
  def both
    @both
  end
  def get_pointer
    object_id
  end
end
class XorLL
  def initialize(node)
    @root = node
    @last = @root
  end
  def add(node)
    @last.add_next(node.get_pointer)
    node.add_prev(@last.get_pointer)
    @last = node
  end
  def get(index)
    node = @root
    prev = 0
    while index > 0 do
      n_node = node.next_node(prev)
      prev = node.get_pointer
      node = n_node
      index -= 1
    end
    return node
  end
  def print
    node = @root
    prev = 0
    while node.is_a?(LLNode) do
      puts "<- #{node.val} ->"
      n_node = node.next_node(prev)
      prev = node.get_pointer
      node = n_node
    end
  end
end

def problem7(encoded)
  counter = []
  if encoded[0].to_i > 0
    counter << [encoded[0],problem7(encoded[1..-1])]
  end
  if counter.size == 1 && encoded[1] && encoded[0..1].to_i <= 26
    counter << [encoded[0..1],problem7(encoded[2..-1])]
  end
  flat_ways = []
  counter.each do |c|
    c[1].each do |c2|
      flat_ways << "#{c[0]} #{c2}"
    end
    flat_ways << c[0] if c[1].empty?
  end

  return flat_ways.uniq
end

def problem9(ar)
  sum = 0
  while ar.count(0) < ar.length do
    max = ar.max
    i = ar.index(max)
    if ar[i+1] == max && i > 0 && i + 1 <= ar.length - 1
      # next is max and not at beginning and not past end
      i = (i + 1 == ar.length - 1 || ar[i-1] > ar[i+2]) ? i + 1 : i
    end
    if max > 0
      sum += max
      ar[i-1] = 0 if i > 0
      ar[i] = 0
      ar[i+1] = 0 if i + 1 < ar.length
    else
      break # biggest won't add to sum anymore
    end
  end
  return sum
end