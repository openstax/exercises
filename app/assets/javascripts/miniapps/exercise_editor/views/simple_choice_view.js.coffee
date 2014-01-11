class ExerciseEditor.SimpleChoiceView extends Marionette.Layout
  template: "simple_choice"

  tagName: "div"
  className: "simple-choice"

  regions:
    content: ".simple-choice-content"

  events:
    'click button.js-delete-choice': "delete"

  initialize: () ->

  onShow: () ->
    @content.show(new ExerciseEditor.ContentView({model: @model.get('content')}))

  ### Controller Methods ###

  delete: () -> @model.destroy()

