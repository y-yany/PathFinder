class CreateMarkers < ActiveRecord::Migration[7.0]
  def change
    create_table :markers do |t|
      t.st_point :location, geographic: true, null: false
      t.integer :order
      t.references :course, foreign_key: true

      t.timestamps
    end

    add_index(:markers, [:course_id, :order], unique: true)
  end
end
