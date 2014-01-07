class ExerciseEditor.SimpleChoices extends Backbone.Collection
  model: ExerciseEditor.SimpleChoice

  comparator: (choice) ->
    choice.get('position')
