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

def problem7(decode)
  
end