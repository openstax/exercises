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

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background')}))
    @questions.show(new ExerciseEditor.QuestionsView({collection: @model.get('questions')}))

  #### Controller Methods ####

  addMcQuestion: () ->
    question = new ExerciseEditor.MultipleChoiceQuestion()
    question.set('stem', new ExerciseEditor.Content())
    question.set('part_id', @model.get('id'))
    @model.get('questions').create(question, {wait: true})
