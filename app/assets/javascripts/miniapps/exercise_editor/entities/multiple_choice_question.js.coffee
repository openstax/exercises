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
      relatedModel: 'ExerciseEditor.SimpleChoice'
    },
    {
      type: Backbone.Many,
      key: 'combo_choices',
      relatedModel: 'ExerciseEditor.ComboChoice'
    }
  ]
