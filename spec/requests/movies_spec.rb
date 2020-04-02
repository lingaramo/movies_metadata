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
end
