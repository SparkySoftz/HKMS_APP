class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :supplier_code, null: false
      t.string :name, null: false
      t.string :phone_number
      t.text :address
      t.string :email

      t.timestamps
    end

    add_index :suppliers, :supplier_code, unique: true
  end
end