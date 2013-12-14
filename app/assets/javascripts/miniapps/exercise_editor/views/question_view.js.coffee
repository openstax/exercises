class ExerciseEditor.QuestionView extends Marionette.Layout
  template: "question"

  tagName: "div"
  className: "question"

  regions:
    format: ".question-format"

  events:
    'click button.js-delete-question': "deleteQuestion"

  initialize: () ->
    @listenTo @model, 'change', @render
    @maintainRegion @format, 
      {
        'multiple_choice_question': ExerciseEditor.MultipleChoiceQuestionView
      }

  deleteQuestion: () ->
    @model.destroy()
    #   success: (model, response) ->
    #     # if model.collection? then model.collection.remove(model)
    # )