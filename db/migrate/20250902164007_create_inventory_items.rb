class CreateInventoryItems < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_items do |t|
      t.string :name
      t.integer :quantity
      t.string :unit
      t.date :expiry_date
      t.references :supplier, null: false, foreign_key: true
      t.string :created_by

      t.timestamps
    end
  end
end
