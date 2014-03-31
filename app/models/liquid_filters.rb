module LiquidFilters
  include ActionView::Helpers::NumberHelper

  def pennies_to_decimal(pennies)
    pennies.to_f / 100
  end
  
  def currency(pennies)
    number_to_currency(pennies_to_decimal(pennies))
  end
  
  def barcode(data)
    "data:image/png;base64,#{Base64.encode64(Barby::Code39.new(data).to_png)}"
  end
  
  def qr_code(data)
    "data:image/svg+xml;charset=utf-8;base64,#{Base64.encode64(Barby::QrCode.new(data).to_svg)}"
  end
end