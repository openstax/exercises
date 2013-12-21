class ExerciseEditor.ComboSimpleChoiceView extends Marionette.ItemView
  template: "combo_simple_choice"

  tagName: "div"
  className: "combo-simple-choice"

  events:
    'click': 'toggle'

  isSelected: () ->
    @options.comboSimpleChoice?

  toggle: () ->
    if @isSelected() then @deselect() else @select()

  select: () ->
    csc = new ExerciseEditor.ComboSimpleChoice()
    csc.set('simple_choice_id', @model.get('id'))
    csc.set('combo_choice_id', @options.comboChoice.get('id'))
    @options.comboChoice.get('combo_simple_choices').create(
      csc, {
        success: (model) => 
          @options.comboSimpleChoice = model
          @render()
        wait: true
      }
    )    

  deselect: () ->
    @options.comboSimpleChoice?.destroy({
      success: () => 
        @options.comboSimpleChoice = null
        @render()
    })

  onRender: () ->
    @$el.toggleClass('selected', @isSelected())

  serializeData: () ->
    { 
      simple_choice: @model.toJSON(), 
      simple_choice_letter: @model.letter()
      combo_simple_choice: @options.comboSimpleChoice?.toJSON() 
    }
