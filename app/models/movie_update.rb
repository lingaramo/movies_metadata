# frozen_string_literal: true

class MovieUpdate
  include ActiveModel::Model

  attr_accessor :id, :name, :synopsis, :minutes, :preview_video_url, :genre_ids
  validates :movie, :name, :synopsis, :minutes, :preview_video_url, :genre_ids, presence: true
  validates_numericality_of :minutes, greater_than: Movie::MINIMUM_MINUTES_VALUE

  validate :genre_ids_must_exist, if: -> { genre_ids.present? }

  def save
    return false unless valid?

    movie.assign_attributes(movie_attrs)
    movie.save
    movie.genres.replace(genres)

    true
  end

  def movie
    @movie ||= Movie.find_by(id: id)
  end

  def genres
    @genres ||= Genre.where(id: genre_ids)
  end

  private

  def movie_attrs
    {
      name: name,
      synopsis: synopsis,
      minutes: minutes,
      preview_video_url: preview_video_url,
    }
  end

  def genre_ids_must_exist
    errors.add(:genre_ids, 'not valid') unless valid_genre_ids?
  end

  def valid_genre_ids?
    genre_ids.map(&:to_i).all? { |id| Genre.ids.include?(id) }
  end
end
