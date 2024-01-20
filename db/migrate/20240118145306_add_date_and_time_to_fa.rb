class AddDateAndTimeToFa < ActiveRecord::Migration[7.1]
  def change
    add_column :fas, :date, :date
    add_column :fas, :time, :time
  end
end
