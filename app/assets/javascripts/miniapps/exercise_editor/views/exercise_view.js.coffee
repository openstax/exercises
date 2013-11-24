class ExerciseEditor.ExerciseView extends Marionette.Layout
  template: "exercise"

  regions:
    background: '.exercise-background'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background')}))

