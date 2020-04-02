# frozen_string_literal: true

class Api::V1::MoviesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: [:index, :show]

  def index
    movies = Movie.eager_load(:scores, :genres).where(id: movie_ids)

    render json: movies
  end

  def show
    render json: Movie.find(params[:id])
  end

  private

  def movie_ids
    return [] if params[:movie_ids].blank?

    params[:movie_ids].split(',').map(&:strip).compact
  end
end
