require_relative './node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    return if array.length.zero?
    return Node.new(array.first) if array.length == 1

    array = array.sort.uniq

    middle = array.length / 2

    left = build_tree(array[0..middle - 1])
    right = build_tree(array[middle + 1..])

    Node.new(array[middle], left, right)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(array)
puts tree.root.data
tree.pretty_print
