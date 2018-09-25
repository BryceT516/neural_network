require_relative 'input_node'
require_relative 'hidden_node'
require_relative 'output_node'

class NetworkManager
  def initialize(hidden_layers:, input_count:, output_count:)
    learning_rate = 1.0

    @input_nodes = []
    input_count.times {@input_nodes << InputNode.new}

    @hidden_layers = []
    hidden_layers.each_with_index do |node_count, index|
      hidden_nodes = []
      if index == 0
        node_count.times { |node_index| hidden_nodes << HiddenNode.new(layer: index, node_index: node_index, parent_nodes_count: @input_nodes.count, learning_rate: learning_rate)}
      else
        node_count.times { |node_index| hidden_nodes << HiddenNode.new(layer: index, node_index: node_index, parent_nodes_count: hidden_layers[index - 1], learning_rate: learning_rate)}
      end
      @hidden_layers << hidden_nodes
    end

    @output_nodes = []
    output_count.times {@output_nodes << OutputNode.new(parent_nodes_count: hidden_layers.last, learning_rate: learning_rate)}

  end

  def train_network(data_row:)
    @output_nodes.first.set_target_output(data_row.pop.to_f)

    data_row.each_with_index do |value, index|
      @input_nodes[index].set_given_input(value.to_f)
    end

    execute_network
# @output_nodes.each{|node| node.describe_itself}
    back_propagate
# @output_nodes.each{|node| node.describe_itself}
    store_train_results
    [@output_nodes.first.actual_output, @output_nodes.first.target_output]
  end

  def test_network(data_row:)
    @output_nodes.first.set_target_output(data_row.pop.to_f)

    data_row.each_with_index do |value, index|
      @input_nodes[index].set_given_input(value.to_f)
    end

    execute_network

    store_test_results
    [@output_nodes.first.actual_output, @output_nodes.first.target_output]
  end

  def use_network(data_row:)
    data_row.each_with_index do |value, index|
      @input_nodes[index].set_given_input(value)
    end
    execute_network
    store_use_results
  end

  def execute_network
    @hidden_layers.each_with_index do |layer, index|
      if index == 0
        parent_nodes = @input_nodes
      else
        parent_nodes = @hidden_layers[index - 1]
      end
      layer.each do |node|
        node.execute(parent_nodes)
      end
    end
    @output_nodes.each do |node|
      node.execute(@hidden_layers.last)
    end
  end

  def back_propagate
    backwards_layers = Array.new(@hidden_layers.reverse)

    @output_nodes.each do |node|
      node.back_propagate(parent_nodes: backwards_layers[0])
    end

    backwards_layers.each_with_index do |layer, index|
      if index == 0
        child_nodes = @output_nodes
      else
        child_nodes = backwards_layers[index - 1]
      end

      if index == backwards_layers.count - 1
        parent_nodes = @input_nodes
      else
        parent_nodes = backwards_layers[index + 1]
      end

      layer.each do |node|
        node.back_propagate(parent_nodes: parent_nodes, child_nodes: child_nodes)
      end
    end
  end

  def set_data_range(minimum_value:, maximum_value:)
    @output_nodes.each{|node| node.set_output_range(minimum_value: minimum_value[4], maximum_value: maximum_value[4])}
    @input_nodes.each_with_index do |node, index|
      node.set_input_range(range_minimum: minimum_value[index], range_maximum: maximum_value[index])
    end
  end

  def store_train_results
    input_values = @input_nodes.map {|node| node.given_input}
    output_values = @output_nodes.map {|node| node.actual_output}
    target_values = @output_nodes.map {|node| node.target_output}
    puts "Training results: Inputs: #{input_values} -> Output: #{output_values}, Target Output: #{target_values}"
  end

  def store_test_results
    input_values = @input_nodes.map {|node| node.given_input}
    output_values = @output_nodes.map {|node| node.actual_output}
    target_values = @output_nodes.map {|node| node.target_output}
    puts "Testing results: Inputs: #{input_values} -> Output: #{output_values}, Target Output: #{target_values}"
  end

  def store_use_results
    output_values = @output_nodes.map {|node| node.actual_output}
    puts "Results: #{output_values}"
  end

  def describe_network
    puts "Network Description..."
    puts "*"*80
    puts "Input Nodes:"
    @input_nodes.each do |node|
      node.describe_itself
    end
    puts "*"*80
    @hidden_layers.each_with_index do |layer, index|
      puts "*"*80
      puts "Layer #{index + 1}:"
      layer.each do |node|
        node.describe_itself
      end
    end
    puts "*"*80
    @output_nodes.each do |node|
      node.describe_itself
    end
    puts "*"*80
  end
end