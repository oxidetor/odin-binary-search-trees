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

  def delete(value, root = @root)
    return if root.nil?

    delete_child(root, 'left') if matching_child?(root.left, value)
    delete_child(root, 'right') if matching_child?(root.right, value)

    delete(value, root.left)
    delete(value, root.right)
  end

  def delete_child(parent, side)
    case direct_children(parent.send(side)).count
    when 0
      parent.send("#{side}=", nil)
    when 1
      parent.send("#{side}=", direct_children(parent.send(side))[0])
    when 2
      case smallest(parent.send(side).right)
      in [smallest, smallest_parent]
        parent.send(side).data = smallest.data
        smallest_parent.left = nil
      end
    end
  end

  def smallest(root, parent = nil)
    return [root, parent] if root.left.nil?

    smallest(root.left, root)
  end

  def matching_child?(root, value)
    !root.nil? && root.data == value
  end

  def direct_children(node)
    [node.left, node.right].compact
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
# tree.delete(4)
# tree.pretty_print
# tree.insert(9)
# tree.pretty_print
# tree.delete(9)
# tree.pretty_print
tree.delete(67)
tree.pretty_print
