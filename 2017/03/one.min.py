def f(i,a=1):
	x=y=b=0
	while 1:
		i-=1
		if i==0:return abs(x)+abs(y)
		x,y=x+a,y+b
		if x==y or x<0and x==-y or x>0and x==1-y:a,b=-b,a

assert f(1) == 0
assert f(12) == 3
assert f(23) == 2
assert f(1024) == 31
print(f(361527))
