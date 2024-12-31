class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title,                            null: false
      t.text :body,                                            default: ""
      t.decimal :distance, precision: 5, scale: 2
      t.string :address,                                       default: ""
      t.string :encoded_polyline,                 null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
