# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :scores

  enumerize :role, in: %i[user admin].freeze, predicates: true
end
