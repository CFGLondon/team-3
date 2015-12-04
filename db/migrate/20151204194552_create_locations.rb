class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :country
      t.string :city
      t.decimal :lat, :null => false, :precision => 17, :scale => 14
      t.decimal :lng, :null => false, :precision => 17, :scale => 14
      t.timestamps null: false
    end

    add_index :locations, :country
    add_index :locations, :city
  end
end
