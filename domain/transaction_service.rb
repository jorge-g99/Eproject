class TransactionService
  def initialize(repository)
    @repository = repository
  end

  def deposit(destination_id, amount)
    account = @repository.find_or_create(destination_id)
    account.balance += amount
    @repository.save(account)
    { destination: { id: account.id, balance: account.balance } }
  end

  def withdraw(origin_id, amount)
    account = @repository.find(origin_id)
    return nil unless account

    account.balance -= amount
    @repository.save(account)
    { origin: { id: account.id, balance: account.balance } }
  end

  def transfer(origin_id, destination_id, amount)
    withdraw_result = withdraw(origin_id, amount)
    return nil unless withdraw_result

    deposit_result = deposit(destination_id, amount)
    return nil unless deposit_result

    {
      origin: withdraw_result[:origin],
      destination: deposit_result[:destination]
    }
  end
end