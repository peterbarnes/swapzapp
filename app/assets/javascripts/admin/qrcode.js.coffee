$(document).ready ->
  $('.qr-code i').hide()
  $('.qr-code').qrcode({
    render: "div",
    correctLevel	: QRErrorCorrectLevel.H,
    text: JSON.stringify($('.qr-code').data('qr-code'))
  })