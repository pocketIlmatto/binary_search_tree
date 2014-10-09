require 'minitest/autorun'
require_relative 'binary_search'

class BinarySearchTest < MiniTest::Unit::TestCase

	def setup
		@btree = BinaryTree.new(10)
		@btree.insert(9)
		@btree.insert(12)
		@btree.insert(11)
		@btree.insert(6)
		@btree.insert(1)
		@btree.insert(19)
		@btree.insert(7)
		@btree.insert(5)
		@btree.insert(17)
		@btree.insert(18)
		@btree.insert(25)
	end

	def test_in_order_traverse_full_tree
		assert_equal [1,5,6,7,9,10,11,12,17,18,19,25], @btree.in_order_traverse
	end

	def test_search_18
		assert_equal 18, @btree.search(18).key
	end

	def test_search_100
		assert_equal nil, @btree.search(100)
	end

	def test_search_recursively_18
		assert_equal 18, @btree.search_recursively(18).key
	end

	def test_search_recursively_100
		assert_equal nil, @btree.search_recursively(100)
	end

	def test_min
		assert_equal 1, @btree.min.key
	end

	def test_max
		assert_equal 25 , @btree.max.key
	end

	def test_predecessor
		assert_equal 10, @btree.predecessor(@btree.search(11)).key
	end

	#tests that modify the tree
	def test_delete_25_no_children
		
		assert_equal 25, @btree.search(25).key
		@btree.delete(25)
		assert_equal nil, @btree.search(25)
		assert_equal nil, @btree.search(19).right
	end
	
	def test_delete_17_one_child
		
		assert_equal 17, @btree.search(17).key
		@btree.delete(17)
		assert_equal nil, @btree.search(17)
		assert_equal 18, @btree.search(19).left.key
		assert_equal 19, @btree.search(18).parent.key
	end

	def test_predecessor_19
		assert_equal 18, @btree.predecessor(@btree.search(19)).key
	end

	def test_swap_18_19
		
		node_18, node_19 = @btree.swap_nodes(@btree.search(18), @btree.search(19))
		#self pointers
		assert_equal 12, node_18.parent.key
		assert_equal 17, node_18.left.key
		assert_equal 25, node_18.right.key
		assert_equal 17, node_19.parent.key
		assert_equal nil, node_19.left
		assert_equal nil, node_19.right
		#parents' child pointers
		assert_equal 18, node_18.parent.right.key
		assert_equal 19, node_19.parent.right.key
		#childrens' parent pointers
		assert_equal 18, node_18.right.parent.key
		assert_equal 18, node_18.left.parent.key
	end

	def test_delete_19_two_children
		assert_equal 19, @btree.search(19).key
		@btree.delete(19)
		assert_equal nil, @btree.search(19)
		assert_equal 12, 	@btree.search(18).parent.key
		assert_equal 17, 	@btree.search(18).left.key
		assert_equal 25, 	@btree.search(18).right.key
		assert_equal nil, @btree.search(17).right
		assert_equal nil, @btree.search(17).left
		assert_equal 18, 	@btree.search(17).parent.key
	end

	def teardown
		@btree = nil
	end

end
