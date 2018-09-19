class OutputNode
  def initialize(parent_nodes_count)
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
  end

  def execute(parent_nodes)
    parent_node_values = parent_nodes.map{ |node| node.current_value }
    @actual_output = (parent_node_values.zip @parent_nodes_weights).reduce(0) do |sum, values|
      sum + values[0] * values[1]
    end
  end

  def back_propogate
    #determine error between actual and target outputs
    # determine weight adjustments
    # apply weight adjustments
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

  private

  def random_weight
    rand
  end

end