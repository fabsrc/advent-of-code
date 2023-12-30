<?

function checksum($input) {
  $box_ids = explode(PHP_EOL, $input);
  $counts = array();

  foreach ($box_ids as $id) {
    $char_count = count_chars($id, 1);
    foreach ([2, 3] as $i) {
      $counts[$i] += in_array($i, $char_count);
    }
  }

  return array_product($counts);
}

assert(checksum("abcdef\nbababc\nabbcde\nabcccd\naabcdd\nabcdee\nababab") === 12);
if ($argv[1]) echo checksum($argv[1]) . "\n";
