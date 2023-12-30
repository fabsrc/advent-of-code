<?

function letter_difference($input) {
  $box_ids = explode(PHP_EOL, $input);
  foreach ($box_ids as $id) {
    foreach ($box_ids as $id2) {
      if (levenshtein($id, $id2) === 1) {
        return implode(array_intersect(str_split($id), str_split($id2)));
      }
    }
  }
}

assert(letter_difference("abcde\nfghij\nklmno\npqrst\nfguij\naxcye\nwvxyz") === "fgij");
if ($argv[1]) echo letter_difference($argv[1]) . "\n";
