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
class XorLLNode
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
    while node.is_a?(XorLLNode) do
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

# problem 11
class Dictionary
  def initialize(words)
    @words = words
    @index = {}
    words.each do |word|
      node = index
      (0..word.size).each do |i|
        sub = word[0..i]
        node[sub] ||= {}
        node[sub][:words] ||= []
        node[sub][:words] << word unless node[sub][:words].include?(word)
        node = node[sub]
      end
    end
  end
  def index
    @index
  end
  def autocomplete(s)
    node = index
    i = 0
    while node.has_key?(s[0..i]) do
      node = node[s[0..i]]
      i += 1
    end
    return node[:words]
  end
end

def problem12(n,set)
  cache = [0]*(n+1)
  cache[0] = 1
  (1..n).each do |i|
    cache[i] += set.reduce(0){|sum,s| sum + (i-s<0 ? 0 : cache[i-s])}
  end
  cache[n]
end

def problem13(k,s)
  counter = 0
  max = 0
  a = 0
  b = 1
  while b-a <= s.size do
    sub = s[a,b]
    if sub.chars.uniq.size > k
      a += 1
      b = 1
    else
      b += 1
      max = [max,sub.chars.size].max
    end
    counter += 1
    if counter > 100
      puts 'break'
      break
    end
  end
  return max
end

def problem14
  inside = 0.0
  outside = 0.0
  pi = 0
  while (pi-3.14159).abs > 0.001 do
    x = 2*rand-1 # -1..1
    y = 2*rand-1 # -1..1
    r = x**2+y**2
    if r<=1
      inside += 1
    else
      outside += 1
    end
    pi = inside/(inside+outside)/r
  end
  return pi
end

def problem15(stream)
  r = nil
  stream.each_with_index do |s,i|
    if i == 0
      r = s
    elsif ((i+1)*rand+1).to_i == 1
      r = s
    end
  end
  return r
end

class OrderList
  def initialize(n)
    @orders = [nil]*n
  end
  def record(order_id)
    @orders = @orders[1..-1]+[order_id]
  end
  def get_last(i)
    @orders[-i]
  end
  def orders
    @orders
  end
end

def problem17(str)
  return 0 unless str =~ /\./
  stack = []
  depth = 0
  sizes = []
  str.split("\n").each do |s|
    d = s.count("\t")
    w = s.gsub("\t",'')
    if d == 0
      stack << w
    else
      if w =~ /\./
        sizes << stack.join('/')+'/'+w
      else
        if d > depth
          stack << w
          depth += 1
        elsif d < depth
          stack.pop
          depth -= 1
        else
          stack[-1] = w
        end
      end
    end
  end
  sizes.map(&:size).max
end

def problem18(ar,k)
  ar.each_cons(k).map(&:max)
end

def problem19(cost)
  total = 0.0
  # pick row with highest average and choose smallest cost
  # repeat until no rows left
  while cost.flatten.compact != [] do
    avgs = cost.map{|c| c.compact == [] ? 0 : c.compact.reduce(0,:+)/c.compact.size.to_f} # get each row's average (excluding column not allowed)
    max = avgs.max
    to_choose = avgs.index(max) # what if max is in avg 2 spots? # 2 rows with same average cost
    choosing = cost[to_choose]
    chosen = choosing.compact.min
    column = choosing.index(chosen) # what if chosen is in choosing in 2 spots? # 2 columns with same cost
    total += chosen
    cost[to_choose] = [nil] * cost[to_choose].size
    cost[to_choose-1][column] = nil if to_choose > 0
    cost[to_choose+1][column] = nil if to_choose < cost.size - 1
  end
  return total
end

puts problem19([[5,6,2],[1,1,6],[2,4,6],[1,4,3]])
puts problem19([[5,6,2],[2,4,3],[1,6,6],[1,4,3]])

# 5 6 2     nil nil 2       nil nil 2    nil nil 2
# 5 6 2     5   6   nil     5   nil nil  5   nil nil
# 1 1 6     1   1   6       nil 1   6    nil 1   nil
# 2 4 6     2   4   6       2   4   6    2   nil nil
# 1 4 3     1   4   3       1   4   3    nil nil   3    => 13

# 5 6 2     nil nil 2     nil nil 2      nil nil 2
# 5 2 6     5   2   nil   nil 2   nil    nil 2   nil
# 1 1 6     1   1   6     1   nil 6      nil nil 6
# 2 4 6     2   4   6     2   4   6      2   nil nil
# 1 4 3     1   4   3     1   4   3      nil nil 3      => 15 but 10 is better

class LLNode
  def initialize(value,n_node=nil,p_node=nil)
    @val = value
    @n_node = n_node
    @p_node = p_node
  end
  def value
    @val
  end
  def next_node
    @n_node
  end
  def prev_node
    @p_node
  end
  def after_size
    1+if @n_node
      @n_node.after_size
    else
      0
    end
  end
  def before_size
    1+if @p_node
      @p_node.before_size
    else
      0
    end
  end
end

puts "\n"
def problem20(a_list,b_list)
  a_size = a_list.after_size
  b_size = b_list.after_size
  while a_size > b_size do
    a_list = a_list.next_node
    a_size -= 1
  end
  while a_size < b_size do
    b_list = b_list.next_node
    b_size -= 1
  end
  while a_list.value != b_list.value do
    a_list = a_list.next_node
    b_list = b_list.next_node
    if a_list.nil? || b_list.nil?
      return nil
    end
  end
  return a_list
end

puts problem20(LLNode.new(21, LLNode.new(3, LLNode.new(7, LLNode.new(8, LLNode.new(10))))), LLNode.new(99, LLNode.new(1, LLNode.new(8, LLNode.new(10))))).inspect