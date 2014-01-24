class ExerciseEditor.LogicOutput extends Backbone.AssociatedModel
  urlRoot: '/api/logic_outputs'

  values: () ->
    JSON.parse(@get('values'))

  # defaults:
  #   markup: '',
  #   html: ''

  # container: () ->
  #   @parents[0]

  # save: (key, val, options) ->
  #   @container().save(key, val, options)