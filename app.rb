require 'sinatra'
require 'json'

$accounts = {}

set :bind, '0.0.0.0'

# ----------------------------
# Reset all accounts
# ----------------------------
post '/reset' do
  $accounts.clear
  status 200
  'OK'
end

# ----------------------------
# Get account balance
# ----------------------------
get '/balance' do
  account_id = params['account_id']
  
  $accounts[account_id]&.then do |balance|
    status 200
    balance.to_s
  end || begin
    status 404
    '0'
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
    destination = data[:destination]
    amount = data[:amount]

    $accounts[destination] ||= 0
    $accounts[destination] += amount

    status 201
    { destination: { id: destination, balance: $accounts[destination] } }.to_json
  
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