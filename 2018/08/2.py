import sys

def metadata_value(input):
  tree = input if isinstance(input, list) else [int(x) for x in input.split()]
  number_of_child_nodes = tree.pop(0)
  number_of_metadata_entries = tree.pop(0)
  values_of_child_nodes = [metadata_value(tree) for _ in range(number_of_child_nodes)]
  metadata_entries = tree[:number_of_metadata_entries]
  del tree[:number_of_metadata_entries]
  
  if (number_of_child_nodes == 0):
    return sum(metadata_entries)
  else:
    return sum([values_of_child_nodes[i-1] for i in metadata_entries if i <= number_of_child_nodes])

assert metadata_value("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2") == 66
if len(sys.argv) > 1:
  print(metadata_value(sys.argv[1]))
