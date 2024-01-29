class AddStatusAndRemarksToBarcodes < ActiveRecord::Migration[7.1]
  def change
    add_column :barcodes, :status, :string
    add_column :barcodes, :remarks, :text
  end
end
