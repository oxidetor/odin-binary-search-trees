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
    elsif value > root.data
      return root.right = Node.new(value) if root.right.nil?

      insert(value, root.right)
    end
  end

  def delete(value, node = @root)
    return if node.nil?

    delete_node(node) if node.data == value
    delete(value, node.left) || delete(value, node.right)
  end

  def delete_node(node)
    case direct_children(node).count
    when 0
      update_parent_pointer(node, nil)
    when 1
      update_parent_pointer(node, *node.direct_children)
    when 2
      smallest = smallest(node.right)
      update_parent_pointer(smallest, nil, 'left')
      node.data = smallest.data
    end
  end

  def update_parent_pointer(node, new_node, side = nil)
    parent = parent(node)
    side ||= parent.left == node ? 'left' : 'right'
    parent.send("#{side}=", new_node)
  end

  def smallest(root)
    return root if root.left.nil?

    smallest(root.left)
  end

  def find(value, root = @root)
    return if root.nil?
    return root if root.data == value

    find(value, root.left) || find(value, root.right)
  end

  def level_order(children_to_visit = [@root], values = [], &block)
    return if children_to_visit.empty?

    current_child = children_to_visit.first
    block.call current_child if block_given?
    values.push current_child.data unless block_given?
    children_to_visit.push(*direct_children(current_child))
    level_order(children_to_visit.drop(1), values, &block)
    values unless block_given?
  end

  def inorder(root = @root, values = [], &block)
    return if root.nil?

    inorder(root.left, values, &block)
    block.call root if block_given?
    values.push root.data unless block_given?
    inorder(root.right, values, &block)
    values unless block_given?
  end

  def preorder(root = @root, values = [], &block)
    return if root.nil?

    block.call root if block_given?
    values.push root.data unless block_given?
    preorder(root.left, values, &block)
    preorder(root.right, values, &block)
    values unless block_given?
  end

  def postorder(root = @root, values = [], &block)
    return if root.nil?

    postorder(root.left, values, &block)
    postorder(root.right, values, &block)
    block.call root if block_given?
    values.push root.data unless block_given?
    values unless block_given?
  end

  def height(node, length = 0, path_lengths = [])
    if node.nil?
      path_lengths.push(length)
      return 0
    end

    height(node.left, length + 1, path_lengths)
    height(node.right, length + 1, path_lengths)

    path_lengths.max - 1
  end

  def depth(node, depth = 0)
    return if node.nil?
    return depth if parent(node).nil?

    depth(parent(node), depth + 1)
  end

  def balanced?(node = @root)
    return if node.nil?

    if direct_children(node).any? { |child| direct_children(child).count.zero? }
      return (height(node&.left) - height(node&.right)).abs <= 1
    end

    balanced?(node.left) && balanced?(node.right)
  end

  def rebalance
    @root = build_tree(inorder(@root))
  end

  def matches?(root, value)
    !root.nil? && root.data == value
  end

  def parent(node, root = @root)
    return if root.nil? || node.nil?
    return root if root.left == node || root.right == node

    parent(node, root.left) || parent(node, root.right)
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
tree.delete(4)
tree.pretty_print
tree.delete(67)
tree.pretty_print
tree.insert(17)
tree.pretty_print

puts 'Level Order'
tree.level_order { |node| puts node }
puts 'Level Order (w/o block)'
p tree.level_order
puts 'In Order'
tree.inorder { |node| puts node }
puts 'In Order (w/o block)'
p tree.inorder
puts 'Pre Order'
tree.preorder { |node| puts node }
puts 'Pre Order (w/o block)'
p tree.preorder
puts 'Post Order'
tree.postorder { |node| puts node }
puts 'Post Order (w/o block)'
p tree.postorder

p tree.height(tree.find(17))
p tree.parent(tree.find(8))
p tree.depth(tree.find(11))
puts tree.balanced?
tree.pretty_print
puts tree.balanced?
tree.delete(17)
tree.pretty_print
tree.insert(27)
tree.pretty_print
puts tree.balanced?
tree.insert(11)
tree.pretty_print
puts tree.balanced?
puts tree.height(tree.find(9))
p tree.inorder
tree.rebalance
tree.pretty_print
puts tree.balanced?
