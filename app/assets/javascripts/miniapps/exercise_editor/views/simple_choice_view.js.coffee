class ExerciseEditor.SimpleChoiceView extends Marionette.Layout
  template: "simple_choice"

  tagName: "div"
  className: "simple-choice"

  regions:
    content: ".choice-content"

  events:
    'click button.js-delete-choice': "delete"

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @content.show(new ExerciseEditor.ContentView({model: @model.get('content')}))

  ### Controller Methods ###

  delete: () -> @model.destroy()
