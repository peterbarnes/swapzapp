SwapzPOS.TabGroupComponent = Ember.Component.extend({
  didInsertElement: function() {
    this.send('resetTabs');
  },
  actions: {
    resetTabs: function() {
      var tabs = this.get('tabs');
      tabs.forEach(function(_tab) {
        _tab.set('active', false);
      })
      tabs.get('firstObject').set('active', true);
      
      var childView = this.get('childViews.firstObject');
      childView.set('active', true);
    },
    showTab: function(tab) {
      var tabs = this.get('tabs');
      tabs.forEach(function(_tab) {
        _tab.set('active', false);
      })
      tab.set('active', true);
      
      var childViews = this.get('childViews');
      childViews.forEach(function(view) {
        if (view.get('key') == tab.get('key')) {
          view.set('active', true);
        } else {
          view.set('active', false);
        }
      });
    }
  }
});