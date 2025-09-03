class StorekeeperController < ApplicationController
  def index
    @transactions = StorekeeperTransaction.all.includes(:supplier)
    @suppliers = Supplier.all
  end

  def new
    @transaction = StorekeeperTransaction.new
    @suppliers = Supplier.all
  end

  def create
    @transaction = StorekeeperTransaction.new(transaction_params)
    @transaction.transaction_id = generate_transaction_id
    if @transaction.save
      redirect_to storekeeper_index_path, notice: 'Transaction successfully created.'
    else
      @suppliers = Supplier.all
      render :new
    end
  end

  private

  def transaction_params
    params.require(:storekeeper_transaction).permit(:supplier_id, :date, :time, :item, :quantity, :unit)
  end
  
  def generate_transaction_id
    # Generate transaction ID in format: TXN-YYYYMMDD-XXXX
    date_prefix = Date.current.strftime("%Y%m%d")
    last_transaction = StorekeeperTransaction.where("transaction_id LIKE ?", "TXN-#{date_prefix}-%").order(:transaction_id).last
    
    if last_transaction
      last_number = last_transaction.transaction_id.split('-').last.to_i
      next_number = last_number + 1
    else
      next_number = 1
    end
    
    "TXN-#{date_prefix}-#{next_number.to_s.rjust(4, '0')}"
  end
end