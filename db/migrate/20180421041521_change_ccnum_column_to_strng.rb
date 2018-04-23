class ChangeCcnumColumnToStrng < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :cc_num, :string
  end
end
