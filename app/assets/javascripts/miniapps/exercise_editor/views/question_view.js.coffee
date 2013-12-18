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

  onShow: () ->
    formatView = switch @model.get('type')
      when 'multiple_choice_question' then ExerciseEditor.MultipleChoiceQuestionView
      else throw 'unknown question type'
    @format.show(new formatView({model: @model}))

  deleteQuestion: () ->
    @model.destroy()