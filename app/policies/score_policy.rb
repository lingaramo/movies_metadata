class ScorePolicy < ApplicationPolicy
  attr_reader :user, :score

  def initialize(user, score)
    @user = user
    @score = score
  end

  def create?
    user.user?
  end

  def destroy?
    user.user? && score.user == user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
