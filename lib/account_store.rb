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
end
