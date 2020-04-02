# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/auth' do
  let(:body) { JSON.parse(response.body) }

  describe 'post' do
    before do
      post '/auth', params: {
        email: 'user@email.com',
        password: 123456,
        password_confirmation: 123456
      }
    end

    it do
      expect(response).to have_http_status(:ok)
    end

    it do
      expect(body['data']).to include('email' => 'user@email.com')
    end
  end
end
