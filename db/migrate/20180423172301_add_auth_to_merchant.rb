class AddAuthToMerchant < ActiveRecord::Migration[5.1]
  def change
        add_column :merchants, :uid, :integer 
  end
end
