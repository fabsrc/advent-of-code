import sys

class Point():
  def __init__(self, coords):
    self.t, self.x, self.y, self.z = coords
    self.label = None
  
  def distance(self, other_point):
    return abs(self.t - other_point.t) + \
      abs(self.x - other_point.x) + \
      abs(self.y - other_point.y) + \
      abs(self.z - other_point.z)
  
  def get_neighbors(self, points):
    return {point for point in points if self.distance(point) <= 3}

def constellation(input):
  coordinates = map(lambda l: map(int, l.split(",")), input.splitlines())
  points = [Point(coord) for coord in coordinates]
  cluster_counter = 0

  for point in points:
    if point.label is not None:
      continue
    neighbors = point.get_neighbors(points)
    if len(neighbors) < 1:
      point.label = False
      continue
    cluster_counter += 1
    point.label = cluster_counter
    while(neighbors):
      neighbor = neighbors.pop()
      if neighbor.label is False:
        neighbor.label = cluster_counter
      if neighbor.label is not None:
        continue
      neighbor.label = cluster_counter
      new_neighbors = neighbor.get_neighbors(points)
      if len(new_neighbors) > 1:
        neighbors.update(new_neighbors)
  
  return cluster_counter

assert constellation(""" 0,0,0,0
 3,0,0,0
 0,3,0,0
 0,0,3,0
 0,0,0,3
 0,0,0,6
 9,0,0,0
12,0,0,0""") == 2
assert constellation("""-1,2,2,0
0,0,2,-2
0,0,0,-2
-1,2,0,0
-2,-2,-2,2
3,0,2,-1
-1,3,2,2
-1,0,-1,0
0,2,1,-2
3,0,0,0""") == 4
assert constellation("""1,-1,0,1
2,0,-1,0
3,2,-1,0
0,0,3,1
0,0,-1,-1
2,3,-2,0
-2,2,0,0
2,-2,0,-1
1,-1,0,-1
3,2,0,2""") == 3
assert constellation("""1,-1,-1,-2
-2,-2,0,1
0,2,1,3
-2,3,-2,1
0,2,3,-2
-1,-1,1,-2
0,-2,-1,0
-2,2,3,-1
1,2,2,0
-1,-2,0,-2""") == 8
if len(sys.argv) > 1:
  print(constellation(sys.argv[1]))
