class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :category_id, null: false
      t.integer :location_id
      t.integer :person_id
      t.timestamps null: false
    end
  end
end
