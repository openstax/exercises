class ExerciseEditor.ExerciseView extends Marionette.Layout
  template: "exercise"

  tagName: "div"
  className: "exercise"

  ui:
    addLogicButton: 'button.js-add-logic'

  events:
    'click button.js-add-part': "addPart"
    'click @ui.addLogicButton': "addLogic"

  regions:
    logic: '.exercise-logic'
    background: '.exercise-background',
    parts: '.exercise-parts'

  onShow: () ->
    @background.show(
      new ExerciseEditor.ContentView { 
        model: @model.get('background'), 
        parent: this, 
        emptyMessage: 'Click here to add background info common to the entire exercise'
      }
    )

    @parts.show(
      new ExerciseEditor.PartsView {collection: @model.get('parts')}
    )

    @showLogic()

  showLogic: () ->
    logic = @model.get('logic')
    if logic? 
      @logic.show(new ExerciseEditor.LogicView {model: logic})
      @ui.addLogicButton.remove()

  addPart: () ->
    part = new ExerciseEditor.Part({position: @model.get('parts').length+1})
    part.set('background', new ExerciseEditor.Content())
    part.set('exercise_id', @model.get('id'))
    @model.get('parts').create(part, {wait: true})

  addLogic: () ->
    return if @model.get('logic')?
    @model.set('logic', new ExerciseEditor.Logic())
    @model.save {}, {
      success: () => @showLogic()
    }

