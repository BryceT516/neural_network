class OutputNode
  def initialize(parent_nodes_count:, learning_rate:)
    @learning_rate = learning_rate
    @parent_nodes_weights = []
    parent_nodes_count.times do
      @parent_nodes_weights << random_weight
    end

    @target_output = nil
    @actual_output = nil
    @parent_nodes_errors = []
    parent_nodes_count.times do
      @parent_nodes_errors << nil
    end
    @error_value = nil
    @maximum_value = nil
    @minimum_value = nil
  end

  def execute(parent_nodes)
    parent_node_values = parent_nodes.map{ |node| node.current_value }
    net_parent_output = (parent_node_values.zip @parent_nodes_weights).reduce(0) do |sum, values|
      sum + values[0] * values[1]
    end
    network_output = (1 / (1 + Math.exp(-(net_parent_output))))
    @actual_output = network_output * @range + @minimum_value
  end

  def back_propagate(parent_nodes:)
    actual_output_scaled = (@actual_output - @minimum_value) / @range
    target_output_scaled = (@target_output - @minimum_value) / @range
    @error_value = actual_output_scaled * (1 - actual_output_scaled) * (target_output_scaled - actual_output_scaled)
    puts " ----------- Error value = #{@error_value} -------------"
    modify_parent_nodes_weights(parent_nodes)
  end

  def set_output_range(minimum_value:, maximum_value:)
    @minimum_value = minimum_value
    @maximum_value = maximum_value
    @range = @maximum_value - @minimum_value
  end

  def set_target_output(value)
    @target_output = value
  end

  def target_output
    @target_output
  end

  def actual_output
    @actual_output
  end

  def parent_node_error(index_value)
    @parent_nodes_errors[index_value]
  end

  def describe_itself
    puts "Output: #{@actual_output}, Target: #{@target_output}, Parent Weights: #{@parent_nodes_weights}"
  end

  def weighted_error(node_index:)
    @error_value * @parent_nodes_weights[node_index]
  end

  private

  def random_weight
    rand
  end

  def modify_parent_nodes_weights(parent_nodes)
    parent_nodes.each_with_index do |node, index|
      @parent_nodes_weights[index] = @parent_nodes_weights[index] + (@learning_rate * @error_value * node.current_value)
    end
  end

end