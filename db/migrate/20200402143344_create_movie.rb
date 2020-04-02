class CreateMovie < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :preview_video_url, null: false, index: { unique: true }
      t.text :synopsis, null: false
      t.integer :minutes, null: false
      t.timestamps
    end
  end
end
