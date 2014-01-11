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
      when @model instanceof ExerciseEditor.SimpleChoice then ExerciseEditor.SimpleChoiceView
      when @model instanceof ExerciseEditor.ComboChoice then ExerciseEditor.ComboChoiceView
      else throw 'unknown choice type'
    @content.show(new contentView({model: @model}))

  serializeData: () ->
    model: @model

  refreshLetter: () ->
    @ui.letter.html(@model.letter())

  drop: (event, index) -> @move(index)

  move: (toPosition) ->
    collection = @model.collection
    collection.models.move(@model.get('position'), toPosition)
    collection.each (model, index) -> model.set('position', index)
    collection.sort()

  delete: () ->
    @model.destroy()