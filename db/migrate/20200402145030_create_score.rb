class CreateScore < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :score, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.references :movie, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end

    add_index :scores, [:user_id, :movie_id], unique: true
  end
end
