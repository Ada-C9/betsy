class AddPetTypeAndPhotoToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :pet_type, :string
    add_column :products, :photo_url, :string
  end
end
