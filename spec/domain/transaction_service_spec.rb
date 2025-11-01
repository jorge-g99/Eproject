require 'spec_helper'
require_relative '../../repositories/account_repository'
require_relative '../../domain/transaction_service'

RSpec.describe TransactionService do
  let(:repository) { AccountRepository.new }
  let(:service) { TransactionService.new(repository) }

  before(:each) { repository.reset! }

  describe '#deposit' do
    it 'creates a new account with initial balance' do
      result = service.deposit('100', 10)
      expect(result[:destination][:balance]).to eq(10)
    end

    it 'adds to existing account balance' do
      service.deposit('100', 10)
      result = service.deposit('100', 5)
      expect(result[:destination][:balance]).to eq(15)
    end
  end

  describe '#withdraw' do
    it 'returns nil for non-existing account' do
      expect(service.withdraw('200', 10)).to be_nil
    end

    it 'reduces balance for existing account' do
      service.deposit('100', 20)
      result = service.withdraw('100', 5)
      expect(result[:origin][:balance]).to eq(15)
    end
  end

  describe '#transfer' do
    it 'returns nil if origin does not exist' do
      expect(service.transfer('200', '300', 15)).to be_nil
    end

    it 'transfers money from existing to new account' do
      service.deposit('100', 20)
      result = service.transfer('100', '300', 15)
      expect(result[:origin][:balance]).to eq(5)
      expect(result[:destination][:balance]).to eq(15)
    end
  end
end
