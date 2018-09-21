require 'csv'

require_relative 'network_manager'

input_data = CSV.open('data.csv')
minimum_value = 100
maximum_value = 1

input_data.each do |row|
  minimum_value = row[4].to_f if row[4].to_f < minimum_value
  maximum_value = row[4].to_f if row[4].to_f > maximum_value
end

minimum_value = minimum_value - ( minimum_value * 0.25 )
maximum_value = maximum_value + ( maximum_value * 0.25 )

puts "Min: #{minimum_value}, Max: #{maximum_value}"

number_of_inputs = 4
number_of_outputs = 1

nodes_in_each_hidden_layer = [6, 10, 6, 3]


puts "Neural Network Program"
puts "Beginning..."
puts "Constructing the Neural Network..."

network = NetworkManager.new(hidden_layers: nodes_in_each_hidden_layer, input_count: number_of_inputs, output_count: number_of_outputs)

puts "Resulting network..."

network.describe_network

network.set_output_range(minimum_value: minimum_value, maximum_value: maximum_value)

data_set_count = 299
training_count = (data_set_count * 0.8).to_i

input_data = CSV.open('data.csv')

training_count.times do
  network.train_network(data_row: input_data.readline)
end

