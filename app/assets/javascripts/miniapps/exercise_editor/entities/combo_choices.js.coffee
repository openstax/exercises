class ExerciseEditor.ComboChoices extends Backbone.Collection
  model: ExerciseEditor.ComboChoice

  comparator: (left, right) ->
    # When collection created, parent might not be set so don't sort
    unless left.collection.parents && left.collection.parents.length > 0 then return 0

    numLeft = left.get('combo_simple_choices').length
    numRight = right.get('combo_simple_choices').length

    # Put None of the aboves last.  There can be more than one while editing.
    if numLeft  == 0 then numLeft  = 10000 + left.get('id')
    if numRight == 0 then numRight = 10000 + right.get('id')

    if numLeft < numRight
      return -1
    else if numLeft > numRight
      return 1
    else
      # equal numbers of choices, put one with lowest simple choice first
      leftPositions  = _.map(left.selectedSimpleChoices(), (sc) -> sc.get('position'))
      rightPositions = _.map(right.selectedSimpleChoices(), (sc) -> sc.get('position'))

      uniquePositions = _.union(_.difference(leftPositions, rightPositions),
                                _.difference(rightPositions, leftPositions))

      if uniquePositions.length == 0 then console.log 'same'; return 0
      if _.indexOf(leftPositions, Math.min.apply(null, uniquePositions)) >= 0
        return -1
      else
        return 1
