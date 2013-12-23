class ExerciseEditor.ComboChoiceView extends Marionette.Layout
  template: "combo_choice"

  tagName: "div"
  className: "combo-choice"

  regions:
    editor: '.editor'
    display: '.display'

  events:
    'dblclick .display': 'edit'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @editor.show(new ExerciseEditor.ComboChoiceEditorView({model: @model}))
    @display.show(new ExerciseEditor.ComboChoiceDisplayView({model: @model}))

  edit: (event) ->
    @display.$el.hide()
    @editor.$el.show()

  ### Controller Methods ###

  delete: () -> @model.destroy()
