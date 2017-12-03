def f(i,a=1):
	x=y=b=0
	v={(0,0):1}
	while 1:
		x,y=x+a,y+b
		if x==y or x<0and x==-y or x>0and x==1-y:a,b=-b,a
		n=[(1,1),(-1,-1),(1,-1),(-1,1),(1,0),(-1,0),(0,1),(0,-1)]
		w=sum([v.get((x+g,y+h),0)for g,h in n])
		v[(x,y)]=w
		if w>i:return w

assert f(1) == 2
assert f(2) == 4
assert f(4) == 5
assert f(5) == 10
print(f(361527))
