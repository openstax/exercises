class ExerciseEditor.ComboChoiceDisplayView extends Marionette.ItemView
  template: "combo_choice_display"

  initialize: () ->

    @listenTo @model, 'change', @render
    @listenTo @model.get('combo_simple_choices'), 'add', @render
    @listenTo @model.get('combo_simple_choices'), 'remove', @render
    @listenTo @simpleChoices(), 'add', @render
    @listenTo @simpleChoices(), 'remove', @render
    @listenTo @simpleChoices(), 'sort', @render

  simpleChoices: () ->
    @cachedSimpleChoices or= @model.simpleChoices()

  serializeData: () ->
    simpleChoices = @simpleChoices()
    selectedSimpleChoiceIds = @model.get('combo_simple_choices').pluck('simple_choice_id')
    selectedSimpleChoices = simpleChoices.filter((sc) -> sc.get('id') in selectedSimpleChoiceIds)

    {
      simpleChoices: simpleChoices
      selectedSimpleChoices: selectedSimpleChoices
    }
