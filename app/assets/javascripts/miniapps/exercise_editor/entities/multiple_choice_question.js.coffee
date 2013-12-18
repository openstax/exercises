class ExerciseEditor.MultipleChoiceQuestion extends ExerciseEditor.Question
  # urlRoot: '/api/formats'

  defaults:
    type: 'multiple_choice_question'

  relations: [
    {
      type: Backbone.One,
      key: 'stem',
      relatedModel: 'ExerciseEditor.Content',
    }
  ]
