# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/movies' do
  let(:body) { JSON.parse(response.body) }
  let(:genres) { create_list(:genre, 1, id: 1, name: 'Thriller') }
  let!(:movie_1) { create(:movie, genres: genres, minutes: 90, preview_video_url: 'https://www.youtube.com/movie_1') }
  let!(:movie_2) { create(:movie, genres: genres, minutes: 105, preview_video_url: 'https://www.youtube.com/movie_2') }

  describe 'get /movies' do
    context 'when movie_ids is not present' do
      it do
        get '/api/v1/movies'
        expect(body).to be_empty
      end
    end

    context 'when movie_ids is present' do
      let(:movie_ids) { "#{movie_1.id},#{movie_2.id}" }
      let(:expected_response) do
        [
          {
            'id' => movie_1.id,
            'name' => movie_1.name,
            'synopsis' => movie_1.synopsis,
            'runtime' => '1 hr 30 min',
            'preview_video_url' => 'https://www.youtube.com/movie_1',
            'avg_score' => 0,
            'created_at' => movie_1.created_at.to_i,
            'updated_at' => movie_1.updated_at.to_i,
            'most_recent_scores' => [],
            'genres' => [{ 'id' => 1, 'name' => 'Thriller' }]

          },
          {
            'id' => movie_2.id,
            'name' => movie_2.name,
            'synopsis' => movie_2.synopsis,
            'runtime' => '1 hr 45 min',
            'preview_video_url' => 'https://www.youtube.com/movie_2',
            'avg_score' => 0,
            'created_at' => movie_2.created_at.to_i,
            'updated_at' => movie_2.updated_at.to_i,
            'most_recent_scores' => [],
            'genres' => [{ 'id' => 1, 'name' => 'Thriller' }]
          }
        ]
      end

      it do
        get '/api/v1/movies', params: { movie_ids: movie_ids }
        expect(body).to match_array(expected_response)
      end

      context "when movie_ids includes a wrong id" do
        let(:movie_ids) { "#{movie_1.id},123Ass@,   1a12" }

        it 'returns only movie_1' do
          get '/api/v1/movies', params: { movie_ids: movie_ids }
          expect(body.size).to eq(1)
          expect(body.first['id']).to eq(movie_1.id)
        end
      end
    end
  end

  describe 'get /movies/:id' do
    let(:avg_score) { 0 }
    let(:most_recent_scores) { [] }
    let(:expected_response) do
      {
        'id' => movie_1.id,
        'name' => movie_1.name,
        'synopsis' => movie_1.synopsis,
        'runtime' => '1 hr 30 min',
        'preview_video_url' => 'https://www.youtube.com/movie_1',
        'avg_score' => avg_score,
        'created_at' => movie_1.created_at.to_i,
        'updated_at' => movie_1.updated_at.to_i,
        'most_recent_scores' => most_recent_scores,
        'genres' => [{ 'id' => 1, 'name' => 'Thriller' }]
      }
    end

    it do
      get "/api/v1/movies/#{movie_1.id}"
      expect(body).to match(expected_response)
    end

    context 'when movie has been scored' do
      let!(:score_1) { create(:score, score: 75, movie: movie_1) }
      let!(:score_2) { create(:score, score: 80, movie: movie_1) }
      let(:avg_score) { 78 }
      let(:most_recent_scores) do
        [
          {'id' => score_1.id, 'user_id' => score_1.user_id, 'score' => score_1.score, 'created_at' => score_1.created_at.to_i},
          {'id' => score_2.id, 'user_id' => score_2.user_id, 'score' => score_2.score, 'created_at' => score_2.created_at.to_i}
        ]
      end

      it do
        get "/api/v1/movies/#{movie_1.id}"
        expect(body).to match(expected_response)
      end
    end
  end

  describe 'post /movies' do
    context 'when request is not authenticated' do
      before { post '/api/v1/movies' }

      it { expect(response.status).to eq(401) }
    end

    context 'when request is made by a user' do
      let(:user) { create(:user, role: :user) }
      before { post '/api/v1/movies', headers: authentication_headers_for(user) }

      it { expect(response.status).to eq(403) }
    end

    context 'when request is made by an admin' do
      let(:admin) { create(:user, role: :admin) }

      context 'when params are not provided' do
        before { post '/api/v1/movies', headers: authentication_headers_for(admin) }

        it { expect(response.status).to eq(400) }

        it do
          expect(body['errors'])
            .to match_array([
              "Name can't be blank",
              "Synopsis can't be blank",
              "Minutes can't be blank",
              "Preview video url can't be blank",
              "Genre ids can't be blank"
            ])
        end
      end

      context 'when correct params are provided' do
        let(:adventure) { create(:genre, name: 'Adventure') }
        let(:comedy) { create(:genre, name: 'Comedy') }
        let(:sci_fi) { create(:genre, name: 'Sci-Fi') }

        let(:params) do
          {
            name: 'Back to the future',
            minutes: 116,
            synopsis: 'Marty McFly, a 17-year-old high school student, is accidentally sent thirty years into the past in a time-traveling DeLorean by his close friend, the eccentric scientist Doc Brown.',
            preview_video_url: 'https://www.youtube.com/watch?v=qvsgGtivCgs',
            genre_ids: [adventure.id, comedy.id, sci_fi.id]
          }
        end

        before { post '/api/v1/movies', params: params, headers: authentication_headers_for(admin) }

        it { expect(response.status).to eq(200) }
      end
    end
  end
end
