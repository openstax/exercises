class ExerciseEditor.PartView extends Marionette.Layout
  template: "part"

  tagName: "div"
  className: "part"

  regions: 
    background: '.part-background',
    questions: '.part-questions'

  events:
    'click button.js-add-question-mc': 'addMcQuestion'

  initialize: () ->
    @listenTo @model, 'change', @render
    @maintainRegion @background, ExerciseEditor.ContentView, {regionModelAttribute: 'background'}
    @maintainRegion @questions, ExerciseEditor.QuestionsView, {regionModelAttribute: 'questions'}

  #### Controller Methods ####

  addMcQuestion: () ->
    debugger
    question = new ExerciseEditor.MultipleChoiceQuestion()
    question.set('stem', new ExerciseEditor.Content())
    @model.get('questions').create(question)
