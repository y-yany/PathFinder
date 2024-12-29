class CreateMarkers < ActiveRecord::Migration[7.0]
  def change
    create_table :markers do |t|

      t.timestamps
    end
  end
end
