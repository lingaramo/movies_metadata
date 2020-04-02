# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  MIN_SCORE = 0
  MAX_SCORE = 100

  validates_numericality_of :score,
                            greater_than_or_equal_to: MIN_SCORE,
                            less_than_or_equal_to: MAX_SCORE
end
