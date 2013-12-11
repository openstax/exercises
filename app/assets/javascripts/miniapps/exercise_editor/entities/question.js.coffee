class ExerciseEditor.Question extends Backbone.RelationalModel
  urlRoot: '/api/questions'

  subModelTypes: 
    'multiple_choice_question': 'ExerciseEditor.MultipleChoiceQuestion'

  # defaults:
    # position: -1

  # relations: [
  #   {
  #     type: Backbone.HasOne,
  #     key: 'format',
  #     relatedModel: 'ExerciseEditor.Format',
  #     reverseRelation: {
  #       type: Backbone.HasOne
  #       key: 'part',
  #       includeInJSON: false
  #     }
  #   }
  # ]

ExerciseEditor.Question.setup()