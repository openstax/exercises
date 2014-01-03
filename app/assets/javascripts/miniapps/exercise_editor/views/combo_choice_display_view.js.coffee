class ExerciseEditor.ComboChoiceDisplayView extends Marionette.ItemView
  template: "combo_choice_display"

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @simpleChoices(), 'add', @render
    @listenTo @simpleChoices(), 'remove', @render
    @listenTo @simpleChoices(), 'sort', @render

  simpleChoices: () ->
    @model.simpleChoices()

  onRender: () ->
    console.log 'rendered cc' + @model.get('id')

  serializeData: () ->
    simpleChoices = @simpleChoices()
    selectedSimpleChoiceIds = @model.get('combo_simple_choices').pluck('simple_choice_id')
    selectedSimpleChoices = simpleChoices.filter((sc) -> sc.get('id') in selectedSimpleChoiceIds)

    {
      simpleChoices: simpleChoices
      selectedSimpleChoices: selectedSimpleChoices
    }
