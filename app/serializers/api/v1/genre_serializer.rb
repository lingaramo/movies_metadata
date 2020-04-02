# frozen_string_literal: true

class Api::V1::GenreSerializer < ActiveModel::Serializer
  attributes :id, :name
end
