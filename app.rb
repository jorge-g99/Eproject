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