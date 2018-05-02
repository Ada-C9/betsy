class AddUidAndProviderToMerchants < ActiveRecord::Migration[5.1]
  def change
      # this is the identifier provided by GitHub
      add_column :merchants, :uid, :integer, null: false
      # this tells us who provided the identifier 
      add_column :merchants, :provider, :string, null: false
  end
end
