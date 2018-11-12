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
  attr_accessor :val, :left, :right, :locked_children
  def initialize(val,left=nil,right=nil)
    @val = val
    @left = left
    @right = right
    @locked = false
    @locked_children = 0
  end
  def add_parent(parent)
    @parent = parent
  end
  def locked?
    @locked
  end
  def can_lock?
    return false if locked_children > 0
    p = @parent
    while p do
      return false if p.locked?
      p = p.parent
    end
    return true
  end
  def lock
    return false if can_lock?
    p = @parent
    while p do
      p.locked_children += 1
      p = p.parent
    end
    @locked = true
    return true
  end
  def unlock
    return false if can_lock?
    p = @parent
    while p do
      p.locked_children -= 1
      p = p.parent
    end
    @locked = false
    return true
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
  best_min = best_prev = nil
  cost.each_with_index do |row,i|
    if i == 0
      best_min = row[0]
      best_prev = 0
      next
    end
    if best_prev == 0
      best_min += row[1]
      best_prev = 1
    else
      best_min += row[0]
      best_prev = 0
    end
  end
  min_for_left = lambda do |cost,min,cur_cost=0,prev=nil|
    return cur_cost if cost[0].nil?
    this_min = nil
    cost[0].each_with_index do |c,i|
      next if i == prev
      next if cur_cost + c > min
      if cost[1].nil? && (this_min.nil? || cur_cost + c < this_min)
        this_min = cur_cost + c
      else
        this_min = [this_min,min_for_left.call(cost[1..-1],min,cur_cost+c,i)].compact.min
      end
    end
    return this_min
  end
  min_for_left.call(cost,best_min)
end

class LLNode
  def initialize(value,n_node=nil,p_node=nil)
    @val = value
    @n_node = n_node
    @p_node = p_node
  end
  def value
    @val
  end
  def next_node=(n_node)
    @n_node = n_node
  end
  def next_node
    @n_node
  end
  def prev_node=(p_node)
    @p_node = p_node
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

def problem21(slots)
  rooms = []
  slots.each do |(stime,etime)|
    room = rooms.find{|room| room.all?{|(st1,et1)| !((st1 <= stime && et1 >= stime) || (st1 <= etime && et1 >= etime) || (st1 >= stime && et1 <= etime))}} # find no overlap
    if room.nil?
      rooms << [[stime,etime]]
    else
      room << [stime,etime]
    end
  end
  rooms.size
end

def problem22(words,sent)
  start = 0
  orig = []
  (0...sent.size).each do |i|
    if words.include?(sent[start..i])
      orig << sent[start..i]
      start = i+1
    end
  end
  return orig.join('') == sent ? orig : nil
end

def problem23(maze,start,finish)
  sr, sc = start
  fr, fc = finish
  empties = maze.flatten.count(false)
  weights = Array.new(maze.size){Array.new(maze[0].size)}
  weights[fr][fc] = 0
  counter = 0
  while weights.flatten.compact.size < empties && counter < maze.size+maze[0].size do
    # this loop will run O(n+m-1) if the maze is do-able
    # so a add a break counter if there is a row or column of walls
    weights.each_index do |wr|
      weights[wr].each_index do |wc|
        next if weights[wr][wc].nil?
        if wr > 0 && !maze[wr-1][wc]
          weights[wr-1][wc] = [weights[wr-1][wc],weights[wr][wc]+1].compact.min
        end
        if wc > 0 && !maze[wr][wc-1]
          weights[wr][wc-1] = [weights[wr][wc-1],weights[wr][wc]+1].compact.min
        end
        if wr < weights.size - 1 && !maze[wr+1][wc]
          weights[wr+1][wc] = [weights[wr+1][wc],weights[wr][wc]+1].compact.min
        end
        if wc < weights[wr].size - 1 && !maze[wr][wc+1]
          weights[wr][wc+1] = [weights[wr][wc+1],weights[wr][wc]+1].compact.min
        end
      end
    end
    counter += 1
  end
  return weights[sr][sc]
end

def problem25(reg,str)
  # return (str =~ /^#{reg}$/) == 0
  i = 0
  ret = ''
  while reg != str do
    r = reg[i]
    if r == '*'
    elsif r == '.'
      if reg[i+1] == '*'
        reg[i+1] == '.*'
      end
      ret[i] = str[i]
    elsif r == str[i]
      ret[i] = str[i]
    else
      break
    end
    i += 1
  end
  return str == ret
end

# puts problem25('ra.','ray')
# puts problem25('ra.','raymond')
# puts problem25('.*at','chat')
# puts problem25('.*at','chats')


def problem26(head,k)
  fast = head
  slow = head
  counter = 0
  while fast do
    fast = fast.next_node
    if counter < k
      counter += 1
    else
      if fast
        slow = slow.next_node
      else
        slow.next_node = slow.next_node.next_node
        break
      end
    end
  end
  return head
end

def problem27(str)
  stack = []
  str.chars.each do |s|
    if (stack[-1] == '(' && s == ')') ||
       (stack[-1] == '[' && s == ']') ||
       (stack[-1] == '{' && s == '}')
      stack.pop
    else
      stack << s
    end
  end
  return stack.empty?
end

def problem28(list,k)
  just = []
  working = ''
  list.each_with_index do |s,j|
    if working.size + s.size + 1 < k
      if working == ''
        working = s
      else
        working = "#{working} #{s}"
      end
      if j == list.size - 1
        counter = 0
        indexes = working.enum_for(:scan,' ').map{Regexp.last_match.offset(0).first}
        while working.size < k
          working[indexes[counter]] = '  '
          indexes = indexes.each_with_index.map{|ind,i| ind+(i > counter ? 1 : 0)}
          counter = (counter+1)%indexes.size
        end
        just << working
      end
    else
      counter = 0
      indexes = working.enum_for(:scan,' ').map{Regexp.last_match.offset(0).first}
      while working.size < k
        working[indexes[counter]] = '  '
        indexes = indexes.each_with_index.map{|ind,i| ind+(i > counter ? 1 : 0)}
        counter = (counter+1)%indexes.size
      end
      just << working
      working = s
    end
    puts working
  end
  return just.inspect
end

def problem29(str)
  ret = ["0#{str[0]}"]
  str.chars.each_with_index do |s,i|
    if s == ret[-1][-1]
      ret[ret.size-1] = "#{ret[ret.size-1].chop.to_i+1}#{s}"
    else
      ret << "1#{s}"
    end
  end
  ret.join
end

def problem30(walls)
  outer = [walls[0],walls[-1]].min

  walls.each_with_index.reduce(0) do |s,(n,i)|
    if i == 0 || i == walls.size - 1
      s
    elsif walls[i-1] > outer && walls[i+1] > outer
      h = [walls[i-1],walls[i+1]].min
      s + (h-[n,h].min)
    else
      s + (outer-[n,outer].min)
    end
  end
end

def problem33(list)
  new_list = []
  list.each do |l|
    if new_list == []
      new_list << l
    else
      i = (0...new_list.size).bsearch{|j| l < new_list[j]}
      if i.nil?
        new_list << l
      else
        if new_list[i+1].nil?
          new_list[i..i+1]=l,new_list[i]
        else
          new_list[i..i+1]=l,new_list[i],new_list[i+1]
        end
      end
    end
    puts new_list[((new_list.size-1)/2.0).floor..((new_list.size-1)/2.0).ceil].reduce(0,:+)/(new_list.size % 2 == 0 ? 2.0 : 1.0)
  end
end

def problem34(str)
  return str if str.reverse == str
  # return str with smaller external palindrome if has 2 external palindrome
  # return str with external non-palindrome if has 1 external palindrome
  words = []
  num = str.size-1
  str.chars.each_with_index do |s,i|
    if i == 0
      words << "#{str[0...-1]}#{str.reverse}"
    elsif i == str.size - 1
      words << "#{str.reverse[0...-1]}#{str}"
    end
  end
  words.sort[0]
end

puts problem34('race') # ecarace comes before ercacre, ecrarce, raecear, reacaer, racecar, recacer, raecear
puts problem34('google') # elgoogle
puts problem34('googleasdfjkllkjfdsael') # googleasdfjkllkjfdsaelgoog
puts problem34('googasdffdsaabba') # abbagoogasdffdsagoogabba # has 2 external palindrones but this answer only adds 8 instead of 12
puts problem34('googlabba') # abbagooglgoogabba comes before abbalgooglabba
puts problem34('googabcdabba') # abbadcbagoogabcdabba comes before googabcdabbadcbagoog
puts problem34('googabcdgoog') # googabcdcbagoog # has 2 external palindromes but this answer only adds 3 instead of 8

def problem35(list)
  point = list.take_while{|i| i == 'R'}.size
  list.each_with_index.reverse_each do |l,i|
    break if point > i
    next unless l == 'R'
    list[point],list[i] = list[i],list[point]
    point += 1
  end
  point = list.take_while{|i| i == 'R' || i == 'G'}.size
  list.each_with_index.reverse_each do |l,i|
    break if point > i
    next unless l == 'G'
    list[point],list[i] = list[i],list[point]
    point += 1
  end
  return list
end

class BSTree
  def initialize(val,left=nil,right=nil)
    @val = val
    @left = left
    @right = right
  end
  def second_max
    return @left.max if !@left.nil? && @right.nil?
    return @right.second_max if @right && !@right.leaf?
    return @val
  end
  def max
    return @val if @right.nil?
    return @right.max
  end
  def leaf?
    @left.nil? && @right.nil?
  end
end

def problem37(list)
  (0..list.size).map{|i| list.combination(i).to_a}.flatten(1)
end

class Stack
  def initialize
    @vals = []
    @sorted = []
  end
  def push(val)
    @vals << val
    @sorted << (@sorted[-1] && @sorted[-1] > val ? @sorted[-1] : val)
  end
  def pop
    @sorted.pop
    @vals.pop
  end
  def max
    @sorted[-1]
  end
end

def problem44(list)
  counter = 0
  list.each_with_index do |l,i|
    list[i+1..-1].each do |l2|
      counter += 1 if l > l2
    end
  end
  counter
end

def problem46(str)
  size = str.size
  size.downto(1).each do |i|
    str.chars.each_cons(i) do |substr|
      substr = substr.join
      return substr if substr.reverse == substr
    end
  end
end