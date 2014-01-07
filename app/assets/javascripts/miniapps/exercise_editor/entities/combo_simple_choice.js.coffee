class ExerciseEditor.ComboSimpleChoice extends Backbone.AssociatedModel
  urlRoot: '/api/combo_simple_choices'

  initialize: () ->
    debugger
    console.log 'hi'

  simpleChoice: () ->
    if @simpleChoice? then return @simpleChoice
    debugger
    @simpleChoice = @collection.parents[0]