# frozen_string_literal: true
require 'sinatra'
require 'json'
require_relative 'lib/account_store'

set :bind, '0.0.0.0'

$accounts = {}
STORE = AccountStore.new

# ----------------------------
# Reset all accounts
# ----------------------------
post '/reset' do
  STORE.reset!
  status 200
  body 'OK'
end

# ----------------------------
# Get account balance
# ----------------------------
get '/balance' do
  account_id = params['account_id']
  if (bal = STORE.balance(account_id))
    status 200
    body bal.to_s
  else
    status 404
    body '0'
  end
end

# ----------------------------
# Event handler (deposit, withdraw, transfer)
# ----------------------------
post '/event' do
  # Parse JSON body with symbol keys
  data = JSON.parse(request.body.read, symbolize_names: true)

  case data[:type]

  # Deposit event
  when 'deposit'
    res = STORE.deposit(data['destination'],data['amount'])
    status 201
    content_type :json
    body res.to_json

  # Withdraw event
  when 'withdraw'
    origin = data[:origin]
    amount = data[:amount]

    $accounts[origin]&.then do
      $accounts[origin] -= amount
      status 201
      { origin: { id: origin, balance: $accounts[origin] } }.to_json
    end || begin
      status 404
      '0'
    end
  
  # Transfer event
  when 'transfer'
    origin = data[:origin]
    destination = data[:destination]
    amount = data[:amount]

    $accounts[origin]&.then do
      $accounts[origin] -= amount
      $accounts[destination] ||= 0
      $accounts[destination] += amount
      status 201
      {
        origin: { id: origin, balance: $accounts[origin] },
        destination: { id: destination, balance: $accounts[destination] }
      }.to_json
    end || begin
      status 404
      '0'
    end

  # Invalid event type
  else
    status 400
    { error: 'Invalid event type' }.to_json
  end
end