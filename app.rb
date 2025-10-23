require 'sinatra'

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