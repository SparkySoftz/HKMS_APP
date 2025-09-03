module ApplicationHelper
  def name_with_code(supplier)
    "#{supplier.name} (#{supplier.supplier_code})"
  end
end