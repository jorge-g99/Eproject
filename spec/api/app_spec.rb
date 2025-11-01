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

      # Após reset, saldo da conta deve não existir
      get '/balance', account_id: '100'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq('0')
    end
  end
end
