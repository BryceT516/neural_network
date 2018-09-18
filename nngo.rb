require 'optparse'

# This will hold the options we parse
options = {}

OptionParser.new do |parser|
  parser.on("-i FILE", "--input FILE", "The input data file.") do |f|
    options[:input_file] = f
  end

  parser.on("-l", "--layers LAYER_COUNT", "The number of layers in the neural network.") do |l|
    options[:network_layers] = l
  end

end.parse!

# Now we can use the options hash however we like.
puts "Input file: #{ options[:input_file] }" if options[:input_file]