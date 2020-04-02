# frozen_string_literal: true

class Api::V1::ScoresController < ApplicationController
  include Pundit
  before_action :authenticate_user!

  def create
    score = current_user.scores.new(creation_params)

    authorize score

    if score.save
      render json: score
    else
      render json: { errors: score.errors.full_messages }, status: :bad_request
    end
  end

  private

  def creation_params
    params.permit(:movie_id, :score)
  end
end
