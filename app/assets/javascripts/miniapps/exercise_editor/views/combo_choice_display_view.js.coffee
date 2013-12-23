class ExerciseEditor.ComboChoiceDisplayView extends Marionette.ItemView
  template: "combo_choice_display"

  initialize: () ->
    @listenTo @model, 'change', @render

  serializeData: () ->
    simpleChoices = @model.question().get('simple_choices')
    selectedSimpleChoiceIds = @model.get('combo_simple_choices').pluck('simple_choice_id')
    selectedSimpleChoices = simpleChoices.filter((sc) -> sc.get('id') in selectedSimpleChoiceIds)

    {
      simpleChoices: simpleChoices
      selectedSimpleChoices: selectedSimpleChoices
    }
