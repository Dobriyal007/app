class AddBarcodeToFa < ActiveRecord::Migration[7.1]
  def change
    add_column :fas, :barcode, :string
  end
end
