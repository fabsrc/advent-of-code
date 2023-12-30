<?php
function spinlock($input) {
  $buffer = array(0);
  $current_position = 0;

  for ($i = 1; $i <= 2017; $i++) {
    $current_position = ($current_position + $input) % $i + 1;
    array_splice( $buffer, $current_position, 0, $i );
  }

  return $buffer[$current_position + 1];
}

assert(spinlock(3) == 638);
print(spinlock(337));
print("\n");
