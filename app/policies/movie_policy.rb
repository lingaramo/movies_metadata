class MoviePolicy < ApplicationPolicy
  attr_reader :user, :movie

  def initialize(user, movie)
    @user = user
    @movie = movie
  end

  def create?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
