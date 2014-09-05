class ExerciseEditor.ChoiceView extends Marionette.Layout
  template: "choice"

  tagName: "div"
  className: "choice"

  regions:
    content: ".choice-content"

  ui:
    letter: '.choice-letter'

  events:
    'click button.js-delete-choice': 'delete'
    'drop': 'drop'

  initialize: () ->
    @listenTo @model, 'change:letter', () -> @refreshLetter()

  onShow: () ->
    contentView = switch 
      when @isSimple() then ExerciseEditor.SimpleChoiceView
      when @isCombo() then ExerciseEditor.ComboChoiceView
      else throw 'unknown choice type'
    @content.show(new contentView({model: @model}))

  isSimple: () ->
    @model instanceof ExerciseEditor.SimpleChoice

  isCombo: () ->
    @model instanceof ExerciseEditor.ComboChoice

  serializeData: () ->
    model: @model
    isSimple: @isSimple()

  refreshLetter: () ->
    @ui.letter.html(@model.letter())

  drop: (event, index) -> @model.collection.move(@model, index)

  delete: () ->
    @model.destroy()