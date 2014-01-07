class ExerciseEditor.SimpleChoice extends Backbone.AssociatedModel
  urlRoot: '/api/simple_choices'

  relations: [
    {
      type: Backbone.One,
      key: 'content',
      relatedModel: 'ExerciseEditor.Content',
    }
  ]

  initialize: (attributes, options) ->
    console.log 'sc init:' + @get('id')
    @listenTo this, 'sync', () -> ExerciseEditor.Store.addModel(this)

  question: () ->
    @collection.parents[0]

  letter: () ->
    String.fromCharCode(96 + @get('position'))