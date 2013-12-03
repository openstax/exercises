class ExerciseEditor.ExerciseView extends Marionette.Layout
  template: "exercise"

  regions:
    background: '.exercise-background',
    parts: '.exercise-parts'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background'), parent: this}))
    @parts.show(new ExerciseEditor.PartsView({collection: @model.get('parts')}))

