SwapzPOS.QrCodeComponent = Ember.Component.extend({
  classNames: ['qr-code', 'img', 'img-thumbnail'],
  metadata: null,
  update: function() {
    this.$().find('i').hide();
    this.$().qrcode({
      render: "div",
      correctLevel  : QRErrorCorrectLevel.H,
      text: JSON.stringify(this.get('metadata'))
    });
  }.observes('metadata'),
  restore: function() {
    this.set('metadata', null);
    this.$().find('i').show();
  }.on('willClearRender'),
});