require_relative './node'

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array.first) if array.length == 1

    middle = array.length / 2
    left = build_tree(array[0..middle - 1])
    right = build_tree(array[middle + 1..])

    Node.new(array[middle], left, right)
  end

  def insert(value, root = @root)
    return nil if value == root.data

    if value < root.data
      root.left.nil? ? root.left = Node.new(value) : insert(value, root.left)
    else
      root.right.nil? ? root.right = Node.new(value) : insert(value, root.right)
    end
  end

  def delete(value)
    matched_node = find(value)
    return nil if matched_node.nil?

    case direct_children(matched_node).count
    when 0
      delete_leaf(matched_node)
    when 1
      delete_half_node(matched_node)
    when 2
      delete_full_node(matched_node)
    end
  end

  def delete_leaf(node)
    update_parent_pointer(node, nil)
  end

  def delete_half_node(node)
    update_parent_pointer(node, *direct_children(node))
  end

  def delete_full_node(node)
    smallest = smallest(node.right)
    update_parent_pointer(smallest, smallest == node.right ? direct_children(smallest).first : nil)
    node.data = smallest.data
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

    if root.data < value
      find(value, root.right)
    elsif root.data > value
      find(value, root.left)
    else
      root
    end
  end

  def level_order(queue = [@root], values = [], &block)
    return if queue.empty?

    block_given? ? block.call(queue.first) : values.push(queue.first.data)
    queue.push(*direct_children(queue.first))
    level_order(queue.drop(1), values, &block)

    values unless block_given?
  end

  def inorder(root = @root, values = [], &block)
    return if root.nil?

    inorder(root.left, values, &block)
    block_given? ? block.call(root) : values.push(root.data)
    inorder(root.right, values, &block)

    values unless block_given?
  end

  def preorder(root = @root, values = [], &block)
    return if root.nil?

    block_given? ? block.call(root) : values.push(root.data)
    preorder(root.left, values, &block)
    preorder(root.right, values, &block)

    values unless block_given?
  end

  def postorder(root = @root, values = [], &block)
    return if root.nil?

    postorder(root.left, values, &block)
    postorder(root.right, values, &block)
    block_given? ? block.call(root) : values.push(root.data)

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
    return sides_height_difference(node) <= 1 if missing_grandchild?(node)

    balanced?(node.left) && balanced?(node.right)
  end

  def sides_height_difference(node)
    (height(node&.left) - height(node&.right)).abs
  end

  def missing_grandchild?(node)
    direct_children(node).any? { |child| direct_children(child).count.zero? }
  end

  def rebalance!
    @root = build_tree(inorder)
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
