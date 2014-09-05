class ExerciseEditor.ComboChoiceView extends Marionette.Layout
  template: "combo_choice"

  tagName: "div"
  className: "combo-choice"

  regions:
    editor: '.editor'
    display: '.display'

  events:
    'dblclick .display': 'showEditor'
    'dblclick .editor': 'doneEditing'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @editor.show(new ExerciseEditor.ComboChoiceEditorView({model: @model}))
    @display.show(new ExerciseEditor.ComboChoiceDisplayView({model: @model}))

  doneEditing: () ->
    @editor.$el.hide()
    @display.$el.show()
    @model.collection.sort()    

  showEditor: (event) ->
    @display.$el.hide()
    @editor.$el.show()

  ### Controller Methods ###

  delete: () -> @model.destroy()
