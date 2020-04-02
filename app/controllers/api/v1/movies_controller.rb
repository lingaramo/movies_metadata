# frozen_string_literal: true

class Api::V1::MoviesController < ApplicationController
  include Pundit
  before_action :authenticate_user!, except: [:index, :show]
end
