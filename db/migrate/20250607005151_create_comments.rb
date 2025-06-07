class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end

    add_index :comments, [:user_id, :course_id], unique: true
  end
end
