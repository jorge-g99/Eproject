# frozen_string_literal: true

class AccountStore
  def initialize
    reset!
  end

  # Zera o estado
  def reset!
    @accounts = {}
    self
  end
end
