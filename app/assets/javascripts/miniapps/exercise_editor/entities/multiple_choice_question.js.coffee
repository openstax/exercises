class ExerciseEditor.MultipleChoiceQuestion extends ExerciseEditor.Question
  # urlRoot: '/api/formats'

  defaults:
    type: 'multiple_choice_question'

  relations: [
    {
      type: Backbone.HasOne,
      key: 'stem',
      relatedModel: 'ExerciseEditor.Content',
      reverseRelation: {
        type: Backbone.HasOne
        key: 'multiple_choice_question',
        includeInJSON: false
      }
    }
  ]

ExerciseEditor.MultipleChoiceQuestion.setup()