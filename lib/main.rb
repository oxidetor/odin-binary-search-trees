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
