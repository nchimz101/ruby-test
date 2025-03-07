
require 'csv'

# Function to process the CSV data
def process_csv(input_file, output_file)
  # Read the CSV file
  rows = CSV.read(input_file, headers: true)

  # Remove duplicates based on the product_id (keeping the first occurrence)
  unique_rows = rows.uniq { |row| row['product_id'] }

  # Process each row
  processed_rows = unique_rows.map do |row|
    # Normalize the price (remove currency symbol, spaces, and ensure two decimals)
    price = row['price'].gsub(/[^\d.]/, '').to_f
    row['price'] = format('%.2f', price)

    # Normalize the stock (set non-integer values and empty fields to 0)
    stock = row['stock'].to_i
    row['stock'] = stock

    # Normalize the supplier email (convert to lowercase)
    row['supplier_email'] = row['supplier_email'].downcase

    row
  end

  # Write the processed data to a new CSV file
  CSV.open(output_file, 'wb') do |csv|
    # Write the header
    csv << rows.headers
    # Write the processed rows
    processed_rows.each { |row| csv << row }
  end

  puts "CSV file processed successfully and saved as #{output_file}"
end

# Specify the input and output file paths
input_file = 'products.csv'
output_file = 'processed_products.csv'

# Call the function to process the CSV
process_csv(input_file, output_file)
