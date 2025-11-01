require_relative '../repositories/account_repository'
require_relative '../domain/transaction_service'

REPOSITORY = AccountRepository.new
SERVICE = TransactionService.new(REPOSITORY)