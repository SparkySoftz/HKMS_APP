class CreateStorekeeperTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :storekeeper_transactions do |t|
      t.string :transaction_id
      t.references :supplier, null: false, foreign_key: true
      t.date :date, null: false
      t.time :time, null: false
      t.string :item, null: false
      t.integer :quantity, null: false

      t.timestamps
    end

    add_index :storekeeper_transactions, :transaction_id, unique: true
  end
end