class ExerciseEditor.ComboChoice extends Backbone.AssociatedModel
  urlRoot: '/api/combo_choices'

  relations: [
    {
      type: Backbone.Many,
      key: 'combo_simple_choices',
      relatedModel: 'ExerciseEditor.ComboSimpleChoice',
    }
  ]

  question: () ->
    @collection.parents[0]