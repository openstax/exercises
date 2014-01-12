class ExerciseEditor.ComboChoicesView extends Marionette.CollectionView
  itemView: ExerciseEditor.ComboChoiceView
  
  tagName: "div"
  className: "combo-choices"

  # onBeforeRender: () ->
    # console.log 'about to sort'
    # @collection.sort()