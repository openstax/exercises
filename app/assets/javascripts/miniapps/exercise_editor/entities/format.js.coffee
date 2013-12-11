class ExerciseEditor.Format extends Backbone.RelationalModel
  # urlRoot: '/api/formats'

  subModelTypes: 
    'multiple_choice_question': 'ExerciseEditor.MultipleChoiceQuestion'

  # defaults:
  #   position: -1

  # relations: [
  #   {
  #     type: Backbone.HasOne,
  #     key: 'background',
  #     relatedModel: 'ExerciseEditor.Content',
  #     reverseRelation: {
  #       type: Backbone.HasOne
  #       key: 'part',
  #       includeInJSON: false
  #     }
  #   }
  # ]

ExerciseEditor.Format.setup()