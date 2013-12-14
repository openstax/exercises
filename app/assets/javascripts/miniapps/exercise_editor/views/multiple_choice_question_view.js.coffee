class ExerciseEditor.MultipleChoiceQuestionView extends Marionette.Layout
  template: "multiple_choice_question"

  tagName: "div"
  className: "multiple-choice-question"

  regions: 
    stem: '.mcq-stem',
    choices: '.mcq-choices'

  initialize: () ->
    @listenTo @model, 'change', @render
    @setupRelationalRegion @stem, ExerciseEditor.ContentView, 'stem'
