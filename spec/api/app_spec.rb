require 'spec_helper'
require 'json'

RSpec.describe 'API Endpoints' do
  before(:each) do
    post '/reset'
    expect(last_response.status).to eq(200)
  end

  describe 'POST /reset' do
    it 'resets the application state' do
      post '/event', { type: 'deposit', destination: '100', amount: 10 }.to_json
      post '/reset'
      expect(last_response.status).to eq(200)

      get '/balance', account_id: '100'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq('0')
    end
  end

  describe 'GET /balance' do
    it 'returns 404 for non-existing account' do
      get '/balance', account_id: '999'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq('0')
    end

    it 'returns 200 with balance for existing account' do
      post '/event', { type: 'deposit', destination: '100', amount: 20 }.to_json
      get '/balance', account_id: '100'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('20')
    end
  end
end
