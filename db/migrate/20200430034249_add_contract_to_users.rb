class AddContractToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :contract, foreign_key: true
  end
end
