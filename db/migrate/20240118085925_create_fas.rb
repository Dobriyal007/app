class CreateFas < ActiveRecord::Migration[7.1]
  def change
    create_table :fas do |t|
      t.integer :Line
      t.text :Model
      t.integer :qty

      t.timestamps
    end
  end
end
