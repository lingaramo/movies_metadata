# frozen_string_literal: true

module SoftDeletableModel
  extend ActiveSupport::Concern

  included do
    scope :latest_version, -> { where(deleted_at: nil) }
  end

  def soft_delete!
    update!(deleted_at: Time.now.utc)
  end

  def undelete!
    update!(deleted_at: nil)
  end

  def deleted?
    deleted_at.present?
  end
end
