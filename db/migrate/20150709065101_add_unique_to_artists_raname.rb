class AddUniqueToArtistsRaname < ActiveRecord::Migration
  def change
    add_index :artists, :raname, unique: true
  end
end
