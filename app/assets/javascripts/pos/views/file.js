SwapzPOS.FileField = Ember.TextField.extend({
  type: 'file',
  fileBinding: ['file'],
  file: null,
  change: function (event) {
    var reader = new FileReader();
    var view = this;
    reader.onload = function (event) {
      var fileToUpload = event.target.result;
      Ember.run(function() {
        view.set('file', fileToUpload);
      });
    };
    return reader.readAsDataURL(event.target.files[0]);
  }
});