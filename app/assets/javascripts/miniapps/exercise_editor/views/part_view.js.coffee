class ExerciseEditor.PartView extends Marionette.Layout
  template: "part"

  tagName: "div"
  className: "part"

  regions: 
    background: '.part-background',
    question: '.part-question'

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'change:background', @resetBackground

  resetBackground: () ->
    @contentView = new ExerciseEditor.ContentView({model: @model.get('background')})
    @background.show(@contentView)

  onShow: () ->
    @resetBackground()
