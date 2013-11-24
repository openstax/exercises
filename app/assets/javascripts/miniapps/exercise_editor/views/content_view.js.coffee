class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  initialize: () ->
    this.listenTo this.model, 'change', this.render
