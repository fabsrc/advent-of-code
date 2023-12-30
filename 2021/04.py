# https://adventofcode.com/2021/day/4
import sys


class Board:
    def __init__(self, lines):
        self.rows = [[int(number) for number in line.split(" ") if number]
                     for line in lines]
        self.cols = list(zip(*self.rows))

    def check_win(self, numbers):
        return any(set(n).issubset(numbers) for n in [*self.rows, *self.cols])

    def get_unmarked_numbers(self, numbers):
        return set(sum(self.rows, [])) - set(numbers)

# Part 1


def get_final_bingo_score_of_first_winning_board(numbers_raw, *boards_raw):
    numbers = [int(n) for n in numbers_raw.split(',')]
    boards = [Board(board.split("\n")) for board in boards_raw]

    for i in range(5, len(numbers)):
        for board in boards:
            current_numbers = numbers[:i]
            if board.check_win(current_numbers):
                last_number = current_numbers[-1]
                unmarked_number_sum = sum(
                    board.get_unmarked_numbers(current_numbers))
                return last_number * unmarked_number_sum

# Part 2


def get_final_bingo_score_of_last_winning_board(numbers_raw, *boards_raw):
    numbers = [int(n) for n in numbers_raw.split(',')]
    boards = [Board(board.split("\n")) for board in boards_raw]

    for i in range(5, len(numbers)):
        for board in boards:
            current_numbers = numbers[:i]
            if board.check_win(current_numbers):
                if len(boards) == 1:
                    last_number = current_numbers[-1]
                    unmarked_number_sum = sum(
                        board.get_unmarked_numbers(current_numbers))
                    return last_number * unmarked_number_sum
                else:
                    boards.remove(board)


test_numbers, *test_boards = [
    "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1",
    "22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19",
    " 3 15  0  2 22\n 9 18 13 17  5\n19  8  7 25 23\n20 11 10 24  4\n14 21 16 12  6",
    "14 21 17 24  4\n10 16 15  9 19\n18  8 23 26 20\n22 11 13  6  5\n 2  0 12  3  7"
]
assert get_final_bingo_score_of_first_winning_board(
    test_numbers, *test_boards) == 4512, "Part 1 failed"
assert get_final_bingo_score_of_last_winning_board(
    test_numbers, *test_boards) == 1924, "Part 2 failed"

if len(sys.argv) > 1:
    numbers, *boards = sys.argv[1].split("\n\n")
    print(get_final_bingo_score_of_first_winning_board(numbers, *boards))
    print(get_final_bingo_score_of_last_winning_board(numbers, *boards))
