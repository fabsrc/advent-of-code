import sys

def sum_of_metadata_entries(input):
  tree = input if isinstance(input, list) else [int(x) for x in input.split()]
  metadata_sum = 0
  number_of_child_nodes = tree.pop(0)
  number_of_metadata_entries = tree.pop(0)

  for _ in range(number_of_child_nodes):
    metadata_sum += sum_of_metadata_entries(tree)

  metadata_sum += sum(tree[:number_of_metadata_entries])
  del tree[:number_of_metadata_entries]
  return metadata_sum

assert sum_of_metadata_entries("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2") == 138
if len(sys.argv) > 1:
  print(sum_of_metadata_entries(sys.argv[1]))
