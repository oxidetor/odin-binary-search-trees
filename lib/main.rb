require_relative './tree'

tree = Tree.new((Array.new(15) { rand(1..100) }))
tree.pretty_print
puts "Balanced: #{tree.balanced?}"

puts "Level Order: #{tree.level_order}"
puts "Pre Order: #{tree.preorder}"
puts "In Order: #{tree.inorder}"
puts "Post Order: #{tree.postorder}"
tree.insert(103)
tree.insert(126)
tree.insert(155)
puts 'Inserted 3 values over 100...'
tree.pretty_print
puts "Balanced: #{tree.balanced?}"
puts 'Rebalancing...'
tree.rebalance!
tree.pretty_print
puts "Balanced: #{tree.balanced?}"

# array = [4, 13, 15, 19, 30, 36, 43, 45, 53, 66, 82, 89, 91, 97, 99, 103, 155]
# tree = Tree.new(array)
# tree.pretty_print
# puts "Balanced: #{tree.balanced?}"
# tree.delete(30)
# tree.pretty_print
# tree.delete(97)
# tree.pretty_print
# tree.delete(99)
# tree.pretty_print
# tree.delete(4)
# tree.pretty_print
# tree.insert(42)
# tree.pretty_print
# tree.delete(36)
# tree.pretty_print
