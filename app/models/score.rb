# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :user
  belongs_to :movie
end
