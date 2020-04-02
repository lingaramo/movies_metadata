# frozen_string_literal: true

class Movie < ApplicationRecord
  include SoftDeletableModel
  
  MINIMUM_MINUTES_VALUE = 0

  has_many :scores
  has_many :movie_genres
  has_many :genres, through: :movie_genres
end
