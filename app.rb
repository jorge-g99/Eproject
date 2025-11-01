require 'sinatra'
require 'json'
require_relative 'lib/account_store'
require_relative 'repositories/account_repository'
require_relative 'domain/transaction_service'

set :bind, '0.0.0.0'

REPOSITORY = AccountRepository.new
SERVICE = TransactionService.new(REPOSITORY)

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
  account_id = params['account_id']
  if (bal = STORE.balance(account_id))
    status 200
    bal.to_s
  else
    status 404
    '0'
  end
end

# ----------------------------
# Event handler (deposit, withdraw, transfer)
# ----------------------------
post '/event' do
  payload_text = request.body.read
  begin
    data = JSON.parse(payload_text)
  rescue JSON::ParserError
    status 400
    return { error: 'invalid json' }.to_json
  end

  case data['type']
  when 'deposit'
    res = STORE.deposit(data['destination'],data['amount'])
    status 201
    content_type :json
    res.to_json

  when 'withdraw'
    res = STORE.withdraw(data['origin'], data['amount'])
    if res
      status 201
      content_type :json
      res.to_json
    else
      status 404
      '0'
    end
  
  when 'transfer'
    res = STORE.transfer(data['origin'], data['destination'], data['amount'])
    if res
      status 201
      content_type :json
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