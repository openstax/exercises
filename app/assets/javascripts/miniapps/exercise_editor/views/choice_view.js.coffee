class ExerciseEditor.ChoiceView extends Marionette.Layout
  template: "choice"

  tagName: "div"
  className: "choice"

  regions:
    content: ".choice-content"

  events:
    'click button.js-delete-choice': 'delete'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    contentView = switch 
      when @model instanceof ExerciseEditor.SimpleChoice then ExerciseEditor.SimpleChoiceView
      when @model instanceof ExerciseEditor.ComboChoice then ExerciseEditor.ComboChoiceView
      else throw 'unknown choice type'
    @content.show(new contentView({model: @model}))

  serializeData: () ->
    model: @model

  delete: () ->
    @model.destroy()