class ExerciseEditor.Part extends Backbone.AssociatedModel
  urlRoot: '/api/parts'

  defaults:
    position: -1,
    credit: -1

  relations: [
    {
      type: Backbone.One,
      key: 'background',
      relatedModel: 'ExerciseEditor.Content',
    },
    {
      type: Backbone.Many,
      key: 'questions',
      relatedModel: (relation, attributes) ->
        return (attrs, options) ->
          if attrs.type == 'multiple_choice_question' then return new ExerciseEditor.MultipleChoiceQuestion(attrs)
          throw "unknown question type"
    }
  ]