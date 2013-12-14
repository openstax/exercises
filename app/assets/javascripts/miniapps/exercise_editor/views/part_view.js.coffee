class ExerciseEditor.PartView extends Marionette.Layout #ExerciseEditor.RelationalLayout
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
    @setupRelationalRegion @background, ExerciseEditor.ContentView, 'background'

  # resetBackground: () ->
  #   @contentView = new ExerciseEditor.ContentView({model: @model.get('background')})
  #   @background.show(@contentView)

  # registerRelationalRegion: (region, view, relationName) ->
  #   @listenTo @model, 'change:' + relationName, () -> @showRelationalRegion(region, view, relationName)
  #   @on 'show', () -> @showRelationalRegion(region, view, relationName)

  # showRelationalRegion: (region, view, relationName) ->
  #   region.show(new view({model: @model.get(relationName)}))


  onShow: () ->
    @questions.show(new ExerciseEditor.QuestionsView({collection: @model.get('questions')}))


  #### Controller Methods ####

  addMcQuestion: () ->
    question = new ExerciseEditor.MultipleChoiceQuestion()
    question.set('stem', new ExerciseEditor.Content())
    @model.get('questions').create(question)
