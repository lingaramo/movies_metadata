# frozen_string_literal: true

class Api::V1::MoviesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: [:index, :show]

  def index
    movies = Movie.eager_load(:scores, :genres).latest_version.where(id: movie_ids)

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

  def update
    movie_update = MovieUpdate.new(update_params)
    authorize movie_update.movie

    if movie_update.save
      render json: movie_update.movie
    else
      render json: { errors: movie_update.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    movie = Movie.find(params[:id])
    authorize movie

    movie.soft_delete!

    head :no_content
  end

  private

  def movie_ids
    return [] if params[:movie_ids].blank?

    params[:movie_ids].split(',').map(&:strip).compact
  end

  def creation_params
    params.permit(:name, :synopsis, :minutes, :preview_video_url, genre_ids: [])
  end

  def update_params
    params.permit(:id, :name, :synopsis, :minutes, :preview_video_url, genre_ids: [])
  end
end
