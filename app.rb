require 'sinatra'
require 'json'
require_relative './config/environment'

set :bind, '0.0.0.0'

before do
  content_type :json
end

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

  result = case data['type']
          when 'deposit'
            SERVICE.deposit(data['destination'], data['amount'])
          when 'withdraw'
            SERVICE.withdraw(data['origin'], data['amount'])
          when 'transfer'
            SERVICE.transfer(data['origin'], data['destination'], data['amount'])
          end
  
  if result
    [201, result.to_json]
  else
    [404, '0']
  end
end