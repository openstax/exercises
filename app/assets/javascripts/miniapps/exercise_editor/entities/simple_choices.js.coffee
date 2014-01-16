class ExerciseEditor.SimpleChoices extends Backbone.Collection
  model: ExerciseEditor.SimpleChoice

  positionField: 'position'

  comparator: (choice) ->
    choice.get(@positionField)

  savePositions: (options={}) ->
    if @models.length == 0 then return

    _.defaults(
      options, 
      {
        url: @models[0].urlRoot + '/sort', 
        attrs: 
          newPositions: @collect (model) => {id: model.get('id'), position: model.get(@positionField)}
      }
    )

    @sync 'update', this, options

  move: (from, to) ->
    if from instanceof Backbone.Model then from = from.get(@positionField)
    @models.move(from, to)
    @each (model, index) => model.set(@positionField, index)
    @sort()
    @savePositions
      error: () =>
        # TODO Should save original positions above and have this error function
        # put the models back in that order.
        alert 'sort order could not be saved, please reload this page'
