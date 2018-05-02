class AddProviderToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :provider, :string
  end
end
