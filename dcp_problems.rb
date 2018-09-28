# Given a list of numbers and a number k, return whether any two numbers from the list add up to k.
# Bonus: single pass
# problem1([10,15,3,7],17) # true
# problem1([10,15,3,17],17) # false
def problem1(ar,k)
  ar.each_with_index.any? do |a,i|
    (ar[0...i]+ar[i+1..-1]).index(k-a)
  end
end

# Given an array of integers, return a new array such that each element at index i of the new array is the product of all the numbers in the original array except the one at i.
# Bonus: no division
# problem2([1,2,3,4,5]) # [120,60,40,30,24]
# problem2([3,2,1]) # [2,3,6]
def problem2(ar)
  ar.map.each_with_index do |a,i|
    (ar[0...i].reduce(1,:*))*(ar[i+1..-1].reduce(1,:*))
  end
end