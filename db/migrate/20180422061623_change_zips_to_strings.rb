class ChangeZipsToStrings < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :cc_zip, :string
    change_column :orders, :mailing_zip, :string
    change_column :orders, :cc_cvv, :string
  end
end
