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
    # console.log 'sc init:' + @get('id')
    ExerciseEditor.Store.addModel(this)
    # @listenTo this, 'sync', () -> ExerciseEditor.Store.addModel(this)
    @listenTo this, 'change:position', () -> @trigger('change:letter')

  question: () ->
    @collection.parents[0]

  letter: () ->
    String.fromCharCode(97 + @get('position'))