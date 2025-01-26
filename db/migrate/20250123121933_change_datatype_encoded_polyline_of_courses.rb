class ChangeDatatypeEncodedPolylineOfCourses < ActiveRecord::Migration[7.0]
  def change
    change_column :courses, :encoded_polyline, :text, null: false
  end
end
