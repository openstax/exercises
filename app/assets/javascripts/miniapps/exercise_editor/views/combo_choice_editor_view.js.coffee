class ExerciseEditor.ComboChoiceEditorView extends Marionette.CompositeView
  template: "combo_choice_editor"

  itemView: ExerciseEditor.ComboSimpleChoiceView

  buildItemView: (item, ItemView, itemViewOptions) ->
    # the item views in general represent the selected simple choices, but to be 
    # able to add ones not yet selected, really we want the item views to represent
    # all possible simple choices, and we want to attach any combo simple choices
    # already present.  So we extend the item view options so that it has the 
    # simple choice, this view's combo choice (see the initializer below), and the
    # combo simple choice if it exists.

    comboSimpleChoice = itemViewOptions.comboChoice.get('combo_simple_choices').find( (csc) -> csc.get('simple_choice_id') == item.id)
    options = _.extend(
      {
        model: item, 
        comboSimpleChoice: comboSimpleChoice
        index: @collection.indexOf(item)
        numItems: @collection.size()
      }, 
      itemViewOptions
    )
    new ExerciseEditor.ComboSimpleChoiceView(options)
    
  itemViewContainer: '.simple-choices'

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @model.simpleChoices(), 'remove', @render
    @listenTo @model.simpleChoices(), 'sort', @render
    # See 'buildItemView' for a relevant discussion about the collection and item
    # view options.
    @collection = @model.question().get('simple_choices')
    @itemViewOptions = { comboChoice: @model }
