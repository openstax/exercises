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
    String.fromCharCode(97 + @collection.indexOf(this) + @question().get('simple_choices').length)

  simpleChoices: () ->
    @question().get('simple_choices')

  selectedSimpleChoices: () ->
    selectedSimpleChoiceIds = @get('combo_simple_choices').pluck('simple_choice_id')
    @simpleChoices().filter((sc) -> sc.get('id') in selectedSimpleChoiceIds)
