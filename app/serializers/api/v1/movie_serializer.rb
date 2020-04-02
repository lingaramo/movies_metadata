# frozen_string_literal: true

class Api::V1::MovieSerializer < ActiveModel::Serializer
  has_many :genres, serializer: Api::V1::GenreSerializer
  has_many :scores, key: :most_recent_scores, serializer: Api::V1::ScoreSerializer

  attributes :id, :name, :synopsis, :preview_video_url, :runtime, :avg_score, :created_at, :updated_at

  def runtime
    minutes = object.minutes
    hours = minutes/60
    minutes = minutes % 60
    "#{hours} hr #{minutes} min"
  end

  def avg_score
    object.scores.average(:score)&.round || 0
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end
