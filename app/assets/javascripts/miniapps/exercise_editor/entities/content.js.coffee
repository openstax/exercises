class ExerciseEditor.Content extends Backbone.RelationalModel
  urlRoot: '/api/contents'

  defaults:
    markup: '',
    html: ''

  # Allows us to get the object containing this Content without polymorphic relations 
  container: () ->
    @get('exercise') or
    @get('part')

  save: (key, val, options) ->
    @container().save(key, val, options)

ExerciseEditor.Content.setup()