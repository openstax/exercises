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
