# https://adventofcode.com/2021/day/13

def fold_paper(
  dots : Array(String),
  folds : Array(String),
  break_after_first_fold : Bool = false
)
  dots = dots.map(&.split(",").map(&.to_i))
  folds = folds.map(&.lchop("fold along ").split("="))
  max_x, max_y = dots.transpose.map(&.max)

  paper = Array(Array(Int32)).new(max_y + 1) {
    Array(Int32).new(max_x + 1) {
      0
    }
  }

  dots.each { |(x, y)| paper[y][x] = 1 }

  folds.each do |(axis, fold_pos)|
    paper = axis == "y" ? paper : paper.transpose!
    paper = paper.shift(fold_pos.to_i).map do |row|
      folded_row = paper.pop
      row.map_with_index { |x, idx| folded_row[idx] | x }
    end
    paper = axis == "y" ? paper : paper.transpose
    break if break_after_first_fold
  end

  yield paper
end

# Part 1
def get_dot_count_after_first_fold(dots : Array(String), folds : Array(String)) : Int32
  fold_paper(dots, folds, true, &.flatten.count(1))
end

# Part 2
def get_code(dots : Array(String), folds : Array(String)) : String
  fold_paper(dots, folds, false, &.map(&.join.tr("01", " #")).join("\n"))
end

test_input = {
  [
    "6,10",
    "0,14",
    "9,10",
    "0,3",
    "10,4",
    "4,11",
    "6,0",
    "6,12",
    "4,1",
    "0,13",
    "10,12",
    "3,4",
    "3,0",
    "8,4",
    "1,10",
    "2,14",
    "8,10",
    "9,0",
  ],
  [
    "fold along y=7",
    "fold along x=5",
  ],
}
raise "Part 1 failed" unless get_dot_count_after_first_fold(*test_input) === 17

if ARGV.size > 0
  dots, folds = ARGV[0].split("\n\n").map(&.split("\n"))
  puts get_dot_count_after_first_fold(dots, folds)
  puts get_code(dots, folds)
end
