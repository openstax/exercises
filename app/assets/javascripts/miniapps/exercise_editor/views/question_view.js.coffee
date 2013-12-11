class ExerciseEditor.QuestionView extends Marionette.Layout
  template: "question"

  tagName: "div"
  className: "question"

  # regions: 
  #   background: '.part-background',
  #   questions: '.part-questions'

  # ui:
  #   'click button.js-add-question-mc': 'addMcQuestion'

  initialize: () ->
    @listenTo @model, 'change', @render
  #   # @listenTo @model, 'change:background', @resetBackground

  # resetBackground: () ->
  #   @contentView = new ExerciseEditor.ContentView({model: @model.get('background')})
  #   @background.show(@contentView)

  # onShow: () ->
  #   @resetBackground()
  #   @questions.show(new ExerciseEditor.QuestionView({collection: @model.get('questions')}))

