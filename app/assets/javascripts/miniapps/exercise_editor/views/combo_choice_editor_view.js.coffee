class ExerciseEditor.ComboChoiceEditorView extends Marionette.CompositeView
  template: "combo_choice_editor"

  # tagName: "div"
  # className: "combo-choice"

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

  # ui:
  #   content: '.choice-content'
  # ui: 
  #   editor: '.editor',
  #   output: '.output'

  # events:
  #   'dblclick': 'edit'
  #   'click button.js-delete-choice': "delete"
    
  itemViewContainer: '.simple-choices'

  initialize: () ->
    @listenTo @model, 'change', @render
    # See 'buildItemView' for a relevant discussion about the collection and item
    # view options.
    @collection = @model.question().get('simple_choices')
    @itemViewOptions = { comboChoice: @model }


  # edit: (event) ->
  #   # alert 'editing'
  #   # @ui.content.toggleClass('editing')
  #   @ui.output.hide()
  #   @ui.editor.show()

  ### Controller Methods ###

  # delete: () -> @model.destroy()
