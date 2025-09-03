class AddUnitToStorekeeperTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :storekeeper_transactions, :unit, :string
  end
end
