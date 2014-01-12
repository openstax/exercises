class ExerciseEditor.SimpleChoices extends Backbone.Collection
  model: ExerciseEditor.SimpleChoice

  comparator: (choice) ->
    choice.get('position')

  savePositions: () ->
    if @models.length == 0 then return
    attrs = {newPositions: {}}
    @each (model) -> attrs['newPositions'][model.get('id')] = model.get('position')
    @sync 'update', 
          this, 
          {
            url: @models[0].urlRoot + '/sort', 
            attrs: attrs
          },
          success: () -> alert 'success',
          error: () -> alert 'failure'
