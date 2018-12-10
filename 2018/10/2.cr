class Point
  property x, y

  def initialize(@x : Int32, @y : Int32, @vx : Int32, @vy : Int32)
  end

  def move
    @x += @vx
    @y += @vy
  end
end

def star_message(input)
  points = input.lines.map{ |l| 
    if match = l.match(/position=<([- ]*\d+), ([- ]*\d+)> velocity=<([- ]*\d+), ([- ]*\d+)/) 
      Point.new(match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i)
    end
  }.compact
  time = 0

  loop do
    points.each(&.move)
    time += 1
    xmin, xmax = points.minmax_of(&.x)
    ymin, ymax = points.minmax_of(&.y)

    if ymax - ymin < 15 # line height is lower than 15
      output =  Array.new(ymax - ymin + 1) { |_| Array.new(xmax - xmin + 1) { |_| "." } }

      points.each do |p|
        output[p.y - ymax - 1][p.x - xmax - 1] = "#"
      end

      output.each do |row|
        row.each do |val|
          print val
        end
        print "\n"
      end
      print "#{time}\n"
    end
  end
end

if ARGV.size == 0
puts star_message("position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>")
else
  puts star_message(ARGV[0])
end
