class ExerciseEditor.PartView extends Marionette.Layout
  template: "part"

  tagName: "div"
  className: "part"

  regions: 
    background: '.part-background',
    questions: '.part-questions'

  events:
    'click button.js-add-question-mc': 'addMcQuestion'
    'click button.js-delete-part': "deletePart"

  ui:
    partNumber: '.part-position'

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @model.collection, 'add remove', @refreshPartNumber

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background')}))
    @questions.show(new ExerciseEditor.QuestionsView({collection: @model.get('questions')}))

  refreshPartNumber: () ->
    if @model.collection.length < 2
      @ui.partNumber.addClass('hidden')
    else
      @ui.partNumber.removeClass('hidden')

  serializeData: () ->
    model: @model

  #### Controller Methods ####

  addMcQuestion: () ->
    question = new ExerciseEditor.MultipleChoiceQuestion()
    question.set('stem', new ExerciseEditor.Content())
    question.set('part_id', @model.get('id'))
    @model.get('questions').create(question, {wait: true})

  deletePart: () ->
    @model.destroy()
    