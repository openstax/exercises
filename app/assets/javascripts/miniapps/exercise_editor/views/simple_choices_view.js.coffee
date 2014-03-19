class ExerciseEditor.SimpleChoicesView extends Marionette.CollectionView
  itemView: ExerciseEditor.ChoiceView
  
  tagName: "div"
  className: "choices"

  onDomRefresh: () ->
    @$el.sortable
      handle: '.choice-handle',
      update: (event, ui) ->
        ui.item.trigger 'drop', ui.item.index()

