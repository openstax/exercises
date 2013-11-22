ExerciseEditor.ExerciseView = Marionette.ItemView.extend
  template: "exercise",
  initialize: () ->
    # bind the model change to re-render this view
    this.listenTo this.model, 'change', this.render
