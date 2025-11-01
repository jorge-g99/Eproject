require 'sinatra'
require 'json'
require_relative 'lib/account_store'
require_relative './config/environment'

set :bind, '0.0.0.0'

before do
  content_type :json
end

STORE = AccountStore.new

# ----------------------------
# Reset all accounts
# ----------------------------
post '/reset' do
  REPOSITORY.reset!
  status 200
  'OK'
end

# ----------------------------
# Get account balance
# ----------------------------
get '/balance' do
  account = REPOSITORY.find(params['account_id'])
  if account
    [200, account.balance.to_s]
  else
    [404, '0']
  end
end

# ----------------------------
# Event handler (deposit, withdraw, transfer)
# ----------------------------
post '/event' do
  data = JSON.parse(request.body.read)

  case data['type']
  when 'deposit'
    res = SERVICE.deposit(data['destination'], data['amount'])
    [201, res.to_json]
  when 'withdraw'
    res = STORE.withdraw(data['origin'], data['amount'])
    if res
      status 201
      res.to_json
    else
      status 404
      '0'
    end
  
  when 'transfer'
    res = STORE.transfer(data['origin'], data['destination'], data['amount'])
    if res
      status 201
      res.to_json
    else
      status 404
      '0'
    end

  else
    status 400
    { error: 'invalid event type' }.to_json
  end
end