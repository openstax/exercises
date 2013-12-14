_.extend Marionette.Layout.prototype,
  setupRelationalRegion: (region, view, relationName) ->
    @listenTo @model, 'change:' + relationName, () -> @showRelationalRegion(region, view, relationName)
    @on 'show', () -> @showRelationalRegion(region, view, relationName)

  showRelationalRegion: (region, view, relationName) ->
    region.show(new view({model: @model.get(relationName)}))