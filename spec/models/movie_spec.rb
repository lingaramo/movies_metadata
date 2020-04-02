# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie do
  let(:movie) { create(:movie) }

  describe '.latest_version' do
    subject { described_class }

    context 'when movie was not deleted' do
      it do
        expect(subject.latest_version).to include(movie)
      end
    end

    context 'when movie was deleted' do
      before { movie.soft_delete! }

      it do
        expect(subject.latest_version).not_to include(movie)
      end
    end
  end

  describe '#soft_delete!' do
    it do
      expect { movie.soft_delete! }.to change { movie.reload.deleted_at }.from(nil)
    end
  end

  describe '#undelete!' do
    let(:movie) { create(:movie, deleted_at: Time.now) }

    it do
      expect { movie.undelete! }.to change { movie.reload.deleted_at }.to(nil)
    end
  end

end
