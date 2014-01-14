class ExerciseEditor.ChoicesView extends Marionette.CollectionView
  itemView: ExerciseEditor.ChoiceView
  
  tagName: "div"
  className: "choices"

  initialize: () ->
    @listenTo @collection, 'sort', @render
