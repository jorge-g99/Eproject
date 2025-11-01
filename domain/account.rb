class Account
  attr_accessor :id, :balance

  def initialize(id:, balance: 0)
    @id = id
    @balance = balance
  end
end