class HiddenNode
  def initialize(layer:, node_index:, parent_nodes_count:)
    @layer = layer
    @node_index = node_index
    @parent_nodes_weights = []
    parent_nodes_count.times do
      @parent_nodes_weights << random_weight
    end

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

  def back_propogate(child_nodes)
    # Use error value provided by child nodes to determine errors of parent weights
    # determine weight adjustments
    # apply weight adjustments
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
  private

  def random_weight
    rand
  end
end