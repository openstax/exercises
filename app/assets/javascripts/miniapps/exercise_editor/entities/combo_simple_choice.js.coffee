class ExerciseEditor.ComboSimpleChoice extends Backbone.AssociatedModel
  urlRoot: '/api/combo_simple_choices'

  initialize: () ->
    @listenToOnce this, 'change:simple_choice_id', () =>
      ExerciseEditor.Store.onModelAvailable('SimpleChoice', @get('simple_choice_id'), (sc) =>
        @listenTo sc, 'destroy', () => 
          # The CSC is already deleted on the server side when an SC is destroyed
          @synclessDestroy()
      )

  simpleChoice: () ->
    if @simpleChoice? then return @simpleChoice
    @simpleChoice = @collection.parents[0]