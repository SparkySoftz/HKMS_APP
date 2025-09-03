class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = Supplier.all
  end

  def show
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      redirect_to suppliers_path, notice: 'Supplier successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: 'Supplier successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @supplier.storekeeper_transactions.any?
      redirect_to suppliers_path, alert: 'Cannot delete supplier with existing transactions.'
    else
      @supplier.destroy
      redirect_to suppliers_path, notice: 'Supplier successfully deleted.'
    end
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:supplier_code, :name, :phone_number, :address, :email)
  end
end