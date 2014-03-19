class ExerciseEditor.ComboSimpleChoiceView extends Marionette.ItemView
  template: "combo_simple_choice"

  tagName: "div"
  className: "combo-simple-choice"

  events:
    'click': 'toggle'

  initialize: () ->
    @simpleChoice = @model
    @comboChoice = @options.comboChoice
    @comboSimpleChoice = @options.comboSimpleChoice

  isSelected: () ->
    @comboSimpleChoice?

  toggle: () ->
    if @isSelected() then @deselect() else @select()

  select: () ->
    csc = new ExerciseEditor.ComboSimpleChoice()
    csc.set('simple_choice_id', @simpleChoice.get('id'))
    csc.set('combo_choice_id', @comboChoice.get('id'))
    @comboChoice.get('combo_simple_choices').create(
      csc, {
        success: (model) => 
          @comboSimpleChoice = model
          @render()
        wait: true
      }
    )  

  deselect: () ->
    @comboSimpleChoice?.destroy({
      success: () => 
        @comboSimpleChoice = null
        @render()
    })

  onRender: () ->
    @$el.toggleClass('selected', @isSelected())

  serializeData: () ->
    simpleChoice: @simpleChoice