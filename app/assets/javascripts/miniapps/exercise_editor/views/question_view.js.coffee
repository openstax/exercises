class ExerciseEditor.QuestionView extends Marionette.Layout
  # template: "question"

  tagName: "div"
  className: "question"

  initialize: () ->
    @listenTo @model, 'change', @render
