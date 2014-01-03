class ExerciseEditor.ComboChoices extends Backbone.Collection
  model: ExerciseEditor.ComboChoice

  comparator: (choice) ->
    # When collection created, parent might not be set so don't sort
    unless choice.collection.parents && choice.collection.parents.length > 0 then return 0

    selectedPositions = _.map(choice.selectedSimpleChoices(), (sc) -> sc.get('position'))

    # Put None of the aboves last.  There can be more than one while editing.
    return 100000 + choice.get('id') if selectedPositions.length == 0

    # Order by number of selected choices, then by highest position of simple choice
    selectedPositions.length*1000 + Math.max.apply(null, selectedPositions)
