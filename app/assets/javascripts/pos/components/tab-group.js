SwapzPOS.TabGroupComponent = Ember.Component.extend({
  actions: {
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
      })
    }
  }
});