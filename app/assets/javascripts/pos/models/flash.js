SwapzPOS.Flash = Ember.Object.extend({
  type : null,
  message : null,
  isSuccess : Ember.computed.equal('type', 'success'),
  isInfo : Ember.computed.equal('type', 'info'),
  isWarning : Ember.computed.equal('type', 'warning'),
  isDanger : Ember.computed.equal('type', 'danger'),
  clear : function(){
    this.update(null, null);
  },
  update : function(type, message){
    this.set('type', type);
    this.set('message', message);
  },
  success : function(message){
    this.update('success', message);
  },
  info : function(message){
    this.update('info', message);
  },
  warning : function(message){
    this.update('warning', message);
  },
  danger : function(message){
    this.update('danger', message);
  }
});