class ExerciseEditor.Content extends Backbone.AssociatedModel
  urlRoot: '/api/contents'

  defaults:
    markup: '',
    html: ''

  container: () ->
    @parents[0]

  save: (key, val, options) ->
    @container().save(key, val, options)