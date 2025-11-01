require 'spec_helper'
require 'json'

RSpec.describe 'API basic test' do
  it 'responds to /reset' do
    post '/reset'
    expect(last_response.status).to eq(200)
  end
end
