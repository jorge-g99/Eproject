require_relative '../domain/account'

class AccountRepository
  def initialize
    @accounts = {}
  end

  def find(id)
    @accounts[id]
  end

  def find_or_create(id)
    @accounts[id] ||= Account.new(id: id)
  end

  def save(account)
    @accounts[account.id] = account
  end

  def reset!
    @accounts = {}
  end
end