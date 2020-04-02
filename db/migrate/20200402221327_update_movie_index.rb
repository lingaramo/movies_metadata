class UpdateMovieIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :movies, :name
    remove_index :movies, :preview_video_url

    add_index :movies, :name
    add_index :movies, :preview_video_url
  end
end
