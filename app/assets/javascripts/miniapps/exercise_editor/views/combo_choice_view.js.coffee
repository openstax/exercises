class ExerciseEditor.ComboChoiceView extends Marionette.ItemView
  template: "combo_choice"

  tagName: "div"
  className: "combo-choice"

  ui: 
    editor: '.combo-choice-edit',
    display: '.combo-choice-show'

  events:
    'click .combo-choice-show': 'edit'
    'click button.js-delete-choice': "delete"
    

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    # @content.show(new ExerciseEditor.ContentView({model: @model.get('content')}))

  edit: () ->
    @ui.display.hide()
    @ui.editor.show()

  ### Controller Methods ###

  onRender: () ->
    # debugger
    # console.log 'here'

  delete: () -> @model.destroy()
