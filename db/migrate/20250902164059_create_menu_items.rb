class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.text :ingredients
      t.date :menu_date
      t.string :status
      t.string :created_by

      t.timestamps
    end
  end
end
