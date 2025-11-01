class TransactionService
  def initialize(repository)
    @repository = repository
  end

  def deposit(destination_id, amount)
    account = @repository.find_or_create(destination_id)
    account.balance += amount
    @repositor.save(account)
    { destination: { id: account.id, balance: account.balance } }
  end
end