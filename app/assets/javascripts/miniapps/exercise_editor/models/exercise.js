var Exercise = Backbone.Model.extend({
  urlRoot: '/api/exercises'
});

var Exercises = Backbone.Collection.extend({
  model: Exercise,
  url: '/api/exercises'
});

