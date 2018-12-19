import sys, itertools
from enum import Enum

def cart_crash_location(input):
  tracks = {}
  carts = []

  class Direction(Enum):
    UP = "^"
    RIGHT = ">"
    DOWN = "v"
    LEFT = "<"
    
    def right(self):
      members = list(self.__class__)
      index = (members.index(self) + 1) % len(members)
      return members[index]
    
    def left(self):
      members = list(self.__class__)
      index = (members.index(self) - 1) % len(members)
      return members[index]
  
  class Cart:
    def __init__(self, x, y, direction):
      self.x = x
      self.y = y
      self.direction = Direction(direction)
      self.turns = 0
    
    def __eq__(self, other):
      return (self.x, self.y) == (other.x, other.y)
    
    def __lt__(self, other):
      return (self.x, self.y) < (other.x, other.y)
    
    def move(self):
      if self.direction is Direction.RIGHT:
        self.x += 1
      elif self.direction is Direction.LEFT:
        self.x -= 1
      elif self.direction is Direction.DOWN:
        self.y += 1
      elif self.direction is Direction.UP:
        self.y -= 1
      self.turn()
    
    def turn(self):
      new_track_part = tracks[self.x, self.y]
      if new_track_part is "+":
        if self.turns is 0:
          self.direction = self.direction.left()
        elif self.turns is 2:
          self.direction = self.direction.right()
        self.turns = (self.turns + 1) % 3
      elif new_track_part is "\\":
        if self.direction is Direction.RIGHT or self.direction is Direction.LEFT:
          self.direction = self.direction.right()
        elif self.direction is Direction.UP or self.direction is Direction.DOWN:
          self.direction = self.direction.left()
      elif new_track_part is "/":
        if self.direction is Direction.RIGHT or self.direction is Direction.LEFT:
          self.direction = self.direction.left()
        elif self.direction is Direction.UP or self.direction is Direction.DOWN:
          self.direction = self.direction.right()

  for y, line in enumerate(input.splitlines()):
    for x, content in enumerate(line):
      if content in Direction._value2member_map_:
        carts.append(Cart(x, y, content))
      tracks[x,y] = content
  
  while(True):
    for cart in sorted(carts):
      cart.move()
      for c1, c2 in itertools.combinations(carts, 2):
        if c1 == c2:
          return '{},{}'.format(c1.x, c1.y)

assert cart_crash_location("""/->-\        
|   |  /----\\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   """) == "7,3"
if len(sys.argv) > 1:
  print(cart_crash_location(sys.argv[1]))
