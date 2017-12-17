<?php
function spinlock($input) {
  $current_position = 0;
  $value_after_zero = 0;

  for ($i = 1; $i <= 50000000; $i++) {
    $current_position = ($current_position + $input) % $i + 1;

    if ($current_position === 1) {
      $value_after_zero = $i;
    }
  }

  return $value_after_zero;
}

print(spinlock(337));
print("\n");
