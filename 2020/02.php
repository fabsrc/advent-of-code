<?php
// https://adventofcode.com/2020/day/2

// Part 1
function count_valid_passwords_with_char_count(iterable $input): int
{
    $valid_password_count = 0;

    foreach ($input as $line) {
        [$min, $max, $char, $password] = preg_split('/[-: ]/', $line, -1, PREG_SPLIT_NO_EMPTY);
        $char_count = substr_count($password, $char);
        
        if ($char_count >= $min && $char_count <= $max) {
            $valid_password_count++;
        }
    }

    return $valid_password_count;
}

assert(count_valid_passwords_with_char_count([
  "1-3 a: abcde",
  "1-3 b: cdefg",
  "2-9 c: ccccccccc"
]) === 2);

// Part 2
function count_valid_passwords_with_char_position(iterable $input): int
{
    $valid_password_count = 0;

    foreach ($input as $line) {
        [$pos_1, $pos_2, $char, $password] = preg_split('/[-: ]/', $line, -1, PREG_SPLIT_NO_EMPTY);

        if ($password[$pos_1 - 1] == $char xor $password[$pos_2 - 1] == $char) {
            $valid_password_count++;
        }
    }

    return $valid_password_count;
}

assert(count_valid_passwords_with_char_position([
  "1-3 a: abcde",
  "1-3 b: cdefg",
  "2-9 c: ccccccccc"
]) === 1);

if ($argv[1]) {
    $input = explode("\n", $argv[1]);
    echo count_valid_passwords_with_char_count($input), PHP_EOL;
    echo count_valid_passwords_with_char_position($input), PHP_EOL;
}
