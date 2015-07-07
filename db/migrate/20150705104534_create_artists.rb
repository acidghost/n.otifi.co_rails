class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :raname, null: false
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
