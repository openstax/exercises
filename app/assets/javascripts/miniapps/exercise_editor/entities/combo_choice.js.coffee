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
    if @collection.parents? and @collection.parents[0] then return @collection.parents[0]

  letter: () ->
    String.fromCharCode(96 + @collection.indexOf(this) + 1 + @question().get('simple_choices').length)

  selectedSimpleChoices: () ->
    selectedSimpleChoiceIds = @get('combo_simple_choices').pluck('simple_choice_id')

    @question().get('simple_choices').filter((sc) -> 
      sc.get('id') in selectedSimpleChoiceIds
    )
