class ExerciseEditor.ExerciseView extends Marionette.Layout
  template: "exercise"

  tagName: "div"
  className: "exercise"

  events:
    'click button.js-add-part': "addPart"

  regions:
    background: '.exercise-background',
    parts: '.exercise-parts'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @background.show(new ExerciseEditor.ContentView({model: @model.get('background'), parent: this}))
    @parts.show(new ExerciseEditor.PartsView({collection: @model.get('parts')}))

  addPart: () ->
    part = new ExerciseEditor.Part()
    part.set('background', new ExerciseEditor.Content())
    @model.get('parts').create(part)

