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

  def create
    movie_creation = MovieCreation.new(creation_params)
    authorize movie_creation.movie

    if movie_creation.save
      render json: movie_creation.movie
    else
      render json: { errors: movie_creation.errors.full_messages }, status: :bad_request
    end
  end

  private

  def movie_ids
    return [] if params[:movie_ids].blank?

    params[:movie_ids].split(',').map(&:strip).compact
  end

  def creation_params
    params.permit(:name, :synopsis, :minutes, :preview_video_url, genre_ids: [])
  end
end
