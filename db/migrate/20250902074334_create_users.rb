class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 50
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, null: false, default: 'customer'
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :phone, limit: 20
      t.string :status, null: false, default: 'active'

      t.timestamps
    end
    
    # Add indexes for performance
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :users, :status
  end
end
