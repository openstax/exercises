class ExerciseEditor.Content extends Backbone.RelationalModel
  urlRoot: '/api/contents'

  defaults:
    markup: '',
    html: '',
    id: ''

  # Allows us to get the object containing this Content without polymorphic relations 
  container: () ->
    @get('exercise') or
    @get('part')

  save: (key, val, options) ->
    @container().save(key, val, options)
