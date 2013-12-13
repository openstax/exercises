class ExerciseEditor.MultipleChoiceQuestionView extends Marionette.Layout
  template: "multiple_choice_question"

  tagName: "div"
  className: "question"

  regions: 
    stem: '.mcq-stem',
    choices: '.mcq-choices'

  initialize: () ->
    super
    @listenTo @model, 'change', @render
    @listenTo @model, 'change:stem', @resetStem

  resetStem: () ->
    @contentView = new ExerciseEditor.ContentView({model: @model.get('stem')})
    @stem.show(@contentView)

  onShow: () ->
    @resetStem()