require 'csv'

data = CSV.read('data.csv')
mixed_data = CSV.open('mixed-data.csv', 'w', write_headers: false)

data.shuffle.each do |row|
  mixed_data << row
end
