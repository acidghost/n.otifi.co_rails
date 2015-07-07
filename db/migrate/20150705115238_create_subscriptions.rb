class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :artist_id, null: false

      t.timestamps null: false
    end

    # Add table index
    add_index :subscriptions, [:user_id, :artist_id], unique: true
  end
end
