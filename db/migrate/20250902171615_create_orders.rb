class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :table, null: false, foreign_key: true
      t.string :customer_name
      t.string :status
      t.decimal :total_amount
      t.datetime :order_date

      t.timestamps
    end
  end
end
