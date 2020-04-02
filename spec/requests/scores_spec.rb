# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/movies/:movie_id/scores' do
  let(:body) { JSON.parse(response.body) }
  let!(:movie) { create(:movie) }

  describe 'post /scores' do
    context 'when request is not authenticated' do
      before { post api_v1_movie_scores_path(movie) }

      it { expect(response.status).to eq(401) }
    end

    context 'when request is made by a user' do
      let(:params) { { score: 100 } }
      let(:user) { create(:user, role: :user) }

      before { post api_v1_movie_scores_path(movie), params: params, headers: authentication_headers_for(user) }

      it { expect(response.status).to eq(200) }

      it do
        expect(body['user_id']).to eq(user.id)
        expect(body['score']).to eq(100)
      end

      context 'when score value is invalid' do
        context 'when value is negative' do
          let(:params) { { score: -1 } }

          it { expect(response.status).to eq(400) }

          it do
            expect(body['errors']).to include('Score must be greater than or equal to 0')
          end
        end

        context 'when value is above maximum' do
          let(:params) { { score: 101 } }

          it { expect(response.status).to eq(400) }

          it do
            expect(body['errors']).to include('Score must be less than or equal to 100')
          end
        end
      end
    end

    context 'when request is made by an admin' do
      let(:admin) { create(:user, role: :admin) }

      before { post api_v1_movie_scores_path(movie), headers: authentication_headers_for(admin) }

      it { expect(response.status).to eq(403) }
    end
  end

  describe 'delete /scores/:id' do
    let!(:score) { create(:score, movie: movie) }

    context 'when request is not authenticated' do
      before { delete api_v1_movie_score_path(movie, score) }

      it { expect(response.status).to eq(401) }
    end

    context 'when request is made by the user who create the score' do
      let(:user) { score.user }

      before { delete api_v1_movie_score_path(movie, score), headers: authentication_headers_for(user) }

      it { expect(response.status).to eq(204) }
    end

    context 'when request is not made by the user who create the score' do
      let(:user) { create(:user, role: :user) }
      before { delete api_v1_movie_score_path(movie, score), headers: authentication_headers_for(user) }

      it { expect(response.status).to eq(403) }
    end

    context 'when request is made by an admin' do
      let(:admin) { create(:user, role: :admin) }

      before { delete api_v1_movie_score_path(movie, score), headers: authentication_headers_for(admin) }

      it { expect(response.status).to eq(403) }
    end
  end
end
