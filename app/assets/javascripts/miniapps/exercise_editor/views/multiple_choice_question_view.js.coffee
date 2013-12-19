class ExerciseEditor.MultipleChoiceQuestionView extends Marionette.Layout
  template: "multiple_choice_question"

  tagName: "div"
  className: "multiple-choice-question"

  regions: 
    stem: '.mcq-stem',
    simpleChoices: '.mcq-simple-choices'

  events:
    'click button.js-add-simple-choice': "addSimpleChoice"


  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @stem.show(new ExerciseEditor.ContentView({model: @model.get('stem')}))
    @simpleChoices.show(new ExerciseEditor.SimpleChoicesView({collection: @model.get('simple_choices')}))

  #### Controller methods ###

  addSimpleChoice: () ->
    choice = new ExerciseEditor.SimpleChoice()
    choice.set('content', new ExerciseEditor.Content())
    choice.set('multiple_choice_question_id', @model.get('id'))
    @model.get('simple_choices').create(choice, {wait: true})
