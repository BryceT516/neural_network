require 'csv'

require_relative 'network_manager'

number_of_inputs = 4
number_of_outputs = 1

nodes_in_each_hidden_layer = [6]


puts "Neural Network Program"
puts "Beginning..."
puts "Constructing the Neural Network..."

network = NetworkManager.new(hidden_layers: nodes_in_each_hidden_layer, input_count: number_of_inputs, output_count: number_of_outputs)

puts "Resulting network..."

network.describe_network


data_set_count = 299
training_count = (data_set_count * 0.8).to_i

input_data = CSV.open('data.csv')

training_count.times do
  network.train_network(data_row: input_data.readline)
end

