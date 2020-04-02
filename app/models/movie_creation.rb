# frozen_string_literal: true

class MovieCreation
  include ActiveModel::Model

  attr_accessor :name, :synopsis, :minutes, :preview_video_url, :genre_ids

  validates :name, :synopsis, :minutes, :preview_video_url, :genre_ids, presence: true
  validate :genre_ids_must_exist, if: -> { genre_ids.present? }

  def save
    return false unless valid?

    movie.save
    movie.genres << genres

    true
  end

  def movie
    @movie ||= Movie.new(movie_attrs)
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
