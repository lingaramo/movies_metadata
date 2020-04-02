class CreateMovieGenre < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_genres do |t|
      t.references :movie, foreign_key: { on_delete: :cascade }, null: false
      t.references :genre, foreign_key: true, null: false
    end

    add_index :movie_genres, [:movie_id, :genre_id], unique: true
  end
end
