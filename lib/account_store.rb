class AccountStore
  def initialize
    reset!
  end

  def reset!
    @accounts = {}
    self
  end

  def balance(account_id)
    @accounts[account_id]
  end

  def deposit(destination, amount)
    dest = destination.to_s
    amt = amount.to_i
    @accounts[dest] ||= 0
    @accounts[dest] += amt
    { 'destination' => { 'id' => dest, 'balance' => @accounts[dest] } }
  end

  def withdraw(origin, amount)
    orig = origin.to_s
    return nil unless @accounts.key?(orig)

    amt = amount.to_i
    @accounts[orig] -= amt
    { 'origin' => { 'id' => orig, 'balance' => @accounts[orig] } }
  end

  def transfer(origin, destination, amount)
    orig = origin.to_s
    dest = destination.to_s
    return nil unless @accounts.key?(orig)

    amt = amount.to_i
    @accounts[orig] -= amt
    @accounts[dest] ||= 0
    @accounts[dest] += amt

    {
      'origin' => { 'id' => orig, 'balance' => @accounts[orig] },
      'destination' => { 'id' => dest, 'balance' => @accounts[dest] }
    }
  end
end
