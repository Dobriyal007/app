class RemoveBarcodeFromFa < ActiveRecord::Migration[7.1]
  def change
    remove_column :fas, :barcode, :string
  end
end
