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

  def insert(value, root = @root)
    if value < root.data
      return root.left = Node.new(value) if root.left.nil?

      insert(value, root.left)
    else
      return root.right = Node.new(value) if root.right.nil?

      insert(value, root.right)
    end
  end

  def delete(value)
    # TODO: When matched node is part of leaf
    # TODO: When matched node has only one child node
    # TODO: When matched node has two children
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
tree.insert(3)
tree.insert(4)
tree.pretty_print
