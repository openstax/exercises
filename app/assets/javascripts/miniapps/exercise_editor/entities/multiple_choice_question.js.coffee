class ExerciseEditor.MultipleChoiceQuestion extends ExerciseEditor.Question

  defaults:
    type: 'multiple_choice_question'

  relations: [
    {
      type: Backbone.One,
      key: 'stem',
      relatedModel: 'ExerciseEditor.Content',
    },
    {
      type: Backbone.Many,
      key: 'simple_choices',
      collectionType: 'ExerciseEditor.SimpleChoices'
    },
    {
      type: Backbone.Many,
      key: 'combo_choices',
      collectionType: 'ExerciseEditor.ComboChoices'
    }
  ]

  constructor: () ->
    @listenTo this, 'change:simple_choices', () ->
      @get('combo_choices').sort()
      @listenTo @get('simple_choices'), 'add remove', () -> @get('combo_choices').sort()

    @listenTo this, 'change:combo_choices', () ->
      @get('combo_choices').sort()

    super