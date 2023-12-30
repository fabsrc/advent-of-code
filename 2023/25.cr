# https://adventofcode.com/2023/day/25

class Graph
  def initialize
    @nodes = Hash(String, Set(String)).new { |hash, k|
      hash[k] = Set(String).new
    }
  end

  def nodes
    @nodes.keys
  end

  def add_edge(u : String, v : String)
    @nodes[u].add(v)
    @nodes[v].add(u)
  end

  def remove_edge(u : String, v : String)
    @nodes[u].delete(v)
    @nodes[v].delete(u)
  end

  def remove_most_valuable_edge
    u, v = get_betweenness.max_by { |_, v| v }.first
    remove_edge(u, v)
  end

  def disconnected_groups
    disconnected_groups = Array(Set(String)).new

    loop do
      seen = Set(String).new
      start_node = nodes.find { |n| disconnected_groups.flat_map(&.to_a).none?(n) }
      break unless start_node
      queue = Deque.new([start_node])

      until queue.empty?
        current = queue.shift
        seen << current
        @nodes[current].each do |n|
          queue << n unless seen.includes?(n)
        end
      end

      disconnected_groups << seen
    end

    disconnected_groups
  end

  private def get_betweenness
    betweenness = Hash(Tuple(String, String), Float64).new(0)

    nodes.each do |node|
      visited = Array(String).new
      p = Hash(String, Array(String)).new

      nodes.each do |v|
        p[v] = [] of String
      end

      sigma = Hash(String, Float64).new(0.0)

      d = Hash(String, Float64).new
      sigma[node] = 1.0
      d[node] = 0
      queue = Deque.new([node])

      until queue.empty?
        current = queue.shift
        visited << current

        @nodes[current].each do |n|
          unless d.has_key?(n)
            queue << n
            d[n] = d[current] + 1
          end

          if d[n] == d[current] + 1
            sigma[n] += sigma[current]
            p[n] << current
          end
        end
      end

      delta = Hash(String, Float64).new(0)

      until visited.empty?
        w = visited.pop
        coeff = (1 + delta[w]) / sigma[w]
        p[w].each do |v|
          c = sigma[v] * coeff
          unless betweenness.has_key?({v, w})
            betweenness[{v, w}] += c
          else
            betweenness[{w, v}] += c
          end
          delta[v] += c
        end
      end
    end

    betweenness
  end
end

# Part 1
def get_product_of_disconnected_group_sizes(wiring_diagram_input : String) : Int32
  graph = Graph.new

  wiring_diagram_input.lines.each do |line|
    component, connected_components = line.split(": ")
    connected_components = connected_components.split(" ")

    connected_components.each do |connected_component|
      graph.add_edge(component, connected_component)
    end
  end

  until graph.disconnected_groups.size > 1
    graph.remove_most_valuable_edge
  end

  graph.disconnected_groups.product(&.size)
end

test_input = <<-INPUT
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
INPUT

raise "Part 1 failed" unless get_product_of_disconnected_group_sizes(test_input) == 54

if ARGV.size > 0
  input = ARGV[0]
  puts get_product_of_disconnected_group_sizes(input)
end
