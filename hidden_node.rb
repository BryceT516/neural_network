class HiddenNode
  def initialize(layer:, node_index:, parent_nodes_count:, learning_rate:)
    @layer = layer
    @node_index = node_index
    @learning_rate = learning_rate
    @parent_nodes_weights = []
    parent_nodes_count.times do
      @parent_nodes_weights << random_weight
    end

    @actual_output = nil
    @parent_nodes_errors = []
    parent_nodes_count.times do
      @parent_nodes_errors << nil
    end
    @error_value = nil
  end

  def execute(parent_nodes)
    parent_node_values = parent_nodes.map{ |node| node.current_value }
    net_parent_output = (parent_node_values.zip @parent_nodes_weights).reduce(0) do |sum, values|
      sum + values[0] * values[1]
    end
    @actual_output = (1 / (1 + Math.exp(-(net_parent_output))))
  end

  def back_propagate(parent_nodes:, child_nodes:)
    # Use error value provided by child nodes to determine errors of parent weights
    sum_of_weighted_child_node_errors = child_nodes.reduce(0){ |sum, node| sum + node.weighted_error(node_index: @node_index) }
    @error_value = @actual_output * (1 - @actual_output) * sum_of_weighted_child_node_errors
    modify_parent_nodes_weights(parent_nodes)
  end

  def current_value
    @actual_output
  end

  def parent_node_error(index_value)
    @parent_nodes_errors[index_value]
  end

  def describe_itself
    puts "Layer #{@layer + 1}, Node #{@node_index} - Output: #{@actual_output}, Parent Weights: #{@parent_nodes_weights}"
  end

  def weighted_error(node_index:)
    @error_value * @parent_nodes_weights[node_index]
  end

  private

  def random_weight
    rand - 0.5
  end

  def modify_parent_nodes_weights(parent_nodes)
    parent_nodes.each_with_index do |node, index|
      @parent_nodes_weights[index] = @parent_nodes_weights[index] + (@learning_rate * @error_value * node.current_value)
    end
  end
end