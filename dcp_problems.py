# problem 5
def cons(a,b):
	def pair(f):
		return f(a,b)
	return pair

def car(f):
	def pair(a,b):
		return a
	return f(pair)

def cdr(f):
	def pair(a,b):
		return b
	return f(pair)