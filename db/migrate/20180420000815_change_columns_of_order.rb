class ChangeColumnsOfOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :street, :string
    add_column :orders, :customer_name, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :mailing_zip, :integer
    add_column :orders, :cc_exp_month, :integer
    add_column :orders, :cc_exp_year, :integer

    remove_column :orders, :mailing_address, :string
    remove_column :orders, :cc_exp, :integer
  end
end
