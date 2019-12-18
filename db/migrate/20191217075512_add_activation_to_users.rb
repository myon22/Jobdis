class AddActivationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activated, :boolean
    add_column :users, :activate_at, :datetime
    add_column :users, :activate_digest, :string
  end
end
