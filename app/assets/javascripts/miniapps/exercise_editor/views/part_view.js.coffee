class ExerciseEditor.PartView extends Marionette.Layout
  template: "part"

  regions: 
    background: '.part-background',
    question: '.part-question'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background')}))