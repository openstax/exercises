ExerciseEditor.CollectionSorting = 

  positionField: 'position'

  initialize: () ->
    # When a model is removed, this will update the remaining positions w/o a sync
    @listenTo this, 'remove', @setPositionsFromIndex

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

  setPositionsFromIndex: () ->
    @each (model, index) => model.set(@positionField, index)

  move: (from, to) ->
    if from instanceof Backbone.Model then from = from.get(@positionField)
    @models.move(from, to)
    @setPositionsFromIndex()
    @sort()
    @savePositions
      error: () =>
        # TODO Should save original positions above and have this error function
        # put the models back in that order.  Maybe can use Model#previousAttributes?
        alert 'sort order could not be saved, please reload this page'
