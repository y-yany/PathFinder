class AddAvatarAndProfileToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar, :string
    add_column :users, :profile, :text
  end
end
