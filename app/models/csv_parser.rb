require 'csv'

class CustomerCsvParser


  ## class methods ##

  def self.customer_from_row(csv_row)
    argument = csv_row.each_with_object({}) do |data, arg|
      column_header = data[0]
      cell_data = data[1]
      if column_header && column_header.downcase.match("company")
        arg[:company] = cell_data
      end
    end
    Customer.create(arg)   
  end


  def self.from_csv_file(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      CustomerCsvParser.customer_from_row(row)
    end
  end


end