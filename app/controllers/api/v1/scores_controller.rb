# frozen_string_literal: true

class ScoreController < ApplicationController
  include Pundit
  before_action :authenticate_user!
end
