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

  describe 'POST /event' do
    context 'deposit' do
      it 'creates new account' do
        post '/event', { type: 'deposit', destination: '100', amount: 10 }.to_json
        expect(last_response.status).to eq(201)
        data = JSON.parse(last_response.body, symbolize_names: true)
        expect(data[:destination][:id]).to eq('100')
        expect(data[:destination][:balance]).to eq(10)
      end

      it 'adds to existing account' do
        post '/event', { type: 'deposit', destination: '100', amount: 10 }.to_json
        post '/event', { type: 'deposit', destination: '100', amount: 15 }.to_json
        data = JSON.parse(last_response.body, symbolize_names: true)
        expect(data[:destination][:balance]).to eq(25)
      end
    end

    context 'withdraw' do
      it 'fails for non-existing account' do
        post '/event', { type: 'withdraw', origin: '200', amount: 10 }.to_json
        expect(last_response.status).to eq(404)
        expect(last_response.body).to eq('0')
      end

      it 'reduces balance for existing account' do
        post '/event', { type: 'deposit', destination: '100', amount: 20 }.to_json
        post '/event', { type: 'withdraw', origin: '100', amount: 5 }.to_json
        data = JSON.parse(last_response.body, symbolize_names: true)
        expect(data[:origin][:balance]).to eq(15)
      end
    end

    context 'transfer' do
      it 'fails if origin does not exist' do
        post '/event', { type: 'transfer', origin: '200', destination: '300', amount: 15 }.to_json
        expect(last_response.status).to eq(404)
        expect(last_response.body).to eq('0')
      end

      it 'transfers money from existing account to new account' do
        post '/event', { type: 'deposit', destination: '100', amount: 15 }.to_json
        post '/event', { type: 'transfer', origin: '100', destination: '300', amount: 15 }.to_json
        data = JSON.parse(last_response.body, symbolize_names: true)
        expect(data[:origin][:balance]).to eq(0)
        expect(data[:destination][:balance]).to eq(15)
      end
    end
  end
end
