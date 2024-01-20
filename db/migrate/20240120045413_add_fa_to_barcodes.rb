class AddFaToBarcodes < ActiveRecord::Migration[7.1]
  def change
    add_reference :barcodes, :fa, null: false, foreign_key: true
  end
end
