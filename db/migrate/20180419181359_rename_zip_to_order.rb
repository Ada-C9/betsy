class RenameZipToOrder < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :zip, :zip_code
  end
end
