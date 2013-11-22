class ExerciseEditor.Content extends Backbone.RelationalModel
  urlRoot: '/api/contents'

  defaults:
    markup: '',
    html: '',
    id: ''
