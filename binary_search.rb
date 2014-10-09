class BinaryTree
	attr_reader :root

	def initialize(num)
		@root = Node.new(key: num)
	end
	
	#TODO deal with duplicates
	def insert(num)
		node = @root
		until node.key == num
			if (num > node.key)
				if (node.right.nil?)
					new_node = Node.new(key: num, parent: node)
					node.right = new_node
					node = new_node
				else
					node = node.right
				end
			else
				if (node.left.nil?)
					new_node = Node.new(key: num, parent: node)
					node.left = new_node
					node = new_node
				else
					node = node.left
				end
			end
		end
	end

	def predecessor(node = @root)
		if node.left.nil?
			num = node.key
			while node.parent.key > num 
				node = node.parent
			end
			node.parent
		else	
			max(node.left)
		end
	end

	def max(node = @root)
		if (node.right.nil?)
			return node
		else
			max (node.right)
		end
	end

	def min(node = @root)
		if (node.left.nil?)
			return node
		else
			min (node.left)
		end
	end

	#TODO what if root is being deleted?  need to reassign the reference
	def delete(num)
		node = search(num)
		until node.nil?
			parent = node.parent
			left = node.left
			right = node.right
			#case 1 - no children
			if (right.nil? && left.nil?)
				update_parent(node, num, nil)
			#case 2 - one child
			elsif (right.nil? ^ left.nil?)
				if left.nil?
					update_parent(node, num, right)
					right.parent = parent
				else
					update_parent(node, num, left)
					left.parent = parent
				end
			#case 3 - two children
			else
				swaped_node, node = swap_nodes(predecessor(node), node)
				if (node.left.nil?)
					update_parent(node, node.key, nil)
				else 
					update_parent(node, node.left.key, node.left)
					left.parent = node.parent
				end
			end
			node = search(num)
		end
	end

	def swap_nodes(node_one, node_two)
		#parents' child pointers
		update_parent(node_one, node_one.key, node_two)
		update_parent(node_two, node_two.key, node_one)
		#children's parent pointers
		update_children(node_one, node_two)
		update_children(node_two, node_one)
		#self
		node_one.left, 		node_two.left 	= node_two.left, 		node_one.left
		node_one.right, 	node_two.right 	= node_two.right, 	node_one.right
		node_one.parent, 	node_two.parent = node_two.parent, 	node_one.parent

		return node_one, node_two
		#children's parent pointers

		# puts "Node 1 key #{node_one.key}"
		# puts "Node 1 left child #{node_one.left.key}"
		# puts "Node 1 right child #{node_one.right.key}"
		# puts "Node 1 parent #{node_one.parent.key}"

		# puts "Node 2 key #{node_two.key}"
		# puts "Node 2 parent #{node_two.parent.key}"

	end

	def search(num)
		#start at root
		if @root.key == num
			return @root
		end
		node = @root
		until node.nil? || node.key == num
			#traverse left/right as needed
			if (num > node.key)
				node = node.right
			else
				node = node.left
			end
		end
		#return node with key k, or Nil
		node
	end

	def search_recursively(num, node = @root)
		if (node.nil?)
			return node
		end

		if (node.key == num)
			return node
		else
			if (num > node.key)
				search_recursively(num, node.right)
			else
				search_recursively(num, node.left)
			end
		end
	end

	#Updates the node's parent's child pointer to point at new_node
	def update_parent(node, num, new_node)
		parent = node.parent
		unless parent.nil?
			if parent.key > num
				parent.left = new_node
			else
				parent.right = new_node
			end
		end
	end

	#Updates the parent pointers of the children of node to point at new_node
	def update_children(node, new_node)
		left 	= node.left
		right = node.right
		left.parent = new_node unless left.nil? 
		right.parent = new_node unless right.nil?
	end

	def in_order_traverse(node = @root, sorted_array = [])
		unless node.left.nil?
			in_order_traverse(node.left, sorted_array)
		end
		sorted_array.push(node.key)
		unless node.right.nil?
			in_order_traverse(node.right, sorted_array)
		end
		sorted_array
	end

end

class Node
	attr_accessor :left, :right, :parent, :key

	def initialize(options = {})
		self.key = options[:key] 
		self.left = options[:left]
		self.right = options[:right]
		self.parent = options[:parent]
	end

	def to_string
		"Key: #{key}, Parent: #{self.parent.nil? ? 'nil' : self.parent.key}, L: #{self.left.nil? ? 'nil' : self.left.key}"
	end

end
