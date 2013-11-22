class ExerciseEditor.ExerciseView extends Marionette.ItemView
  template: "exercise"

  initialize: () ->
    this.listenTo this.model, 'change', this.render
