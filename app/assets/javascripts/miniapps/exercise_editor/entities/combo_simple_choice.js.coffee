class ExerciseEditor.ComboSimpleChoice extends Backbone.AssociatedModel
  urlRoot: '/api/combo_simple_choices'

  simpleChoice: () ->
    if @simpleChoice? then return @simpleChoice
    @simpleChoice = @collection.parents[0]