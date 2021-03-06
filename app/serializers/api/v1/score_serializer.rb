# frozen_string_literal: true

class Api::V1::ScoreSerializer < ActiveModel::Serializer
  attributes :id, :score, :user_id, :created_at

  def created_at
    object.created_at.to_i
  end
end
