module ApplicationHelper
  def qr_code_as_svg(url)
    require 'rqrcode'
    qr = RQRCode::QRCode.new(url)
    qr.as_svg(
      module_size: 4,
      standalone: true
    ).html_safe
  end
end
