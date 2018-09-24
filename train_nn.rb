require 'csv'

require_relative 'network_manager'

input_data = CSV.open('mixed-data.csv')
minimum_value = [1000, 1000, 1000, 1000, 1000]
maximum_value = [1, 1, 1, 1, 1]

input_data.each do |row|
  row.each_with_index do |value, index|
    minimum_value[index] = value.to_f if value.to_f < minimum_value[index]
    maximum_value[index] = value.to_f if value.to_f > maximum_value[index]
  end

end

minimum_value = minimum_value.map do |value|
  value - (value * 0.25)
end
maximum_value = maximum_value.map do |value|
  value + (value * 0.25)
end

minimum_value.zip(maximum_value).each do |min_val, max_val|
  puts "Min: #{min_val}, Max: #{max_val}"
end

number_of_inputs = 4
number_of_outputs = 1

nodes_in_each_hidden_layer = [3, 2]


puts "Neural Network Program"
puts "Beginning..."
puts "Constructing the Neural Network..."

network = NetworkManager.new(hidden_layers: nodes_in_each_hidden_layer, input_count: number_of_inputs, output_count: number_of_outputs)

puts "Resulting network..."

network.describe_network

network.set_data_range(minimum_value: minimum_value, maximum_value: maximum_value)

data_set_count = 299
training_count = (data_set_count * 0.8).to_i

input_data = CSV.open('mixed-data.csv')
training_output = CSV.open('training_output.csv', 'w', write_headers: false)

training_count.times do
  results = network.train_network(data_row: input_data.readline)
  results << (results[0] - results[1]).abs
  training_output << results
end

testing_count = data_set_count - training_count
testing_output = CSV.open('testing_output.csv', 'w', write_headers: false)

testing_count.times do
  results = network.test_network(data_row: input_data.readline)
  results << (results[0] - results[1]).abs
  testing_output << results
end

network.describe_network
