_.extend Marionette.Layout.prototype,
  maintainRegion: (region, view, options={}) ->
    debugger

    viewIsCollection = view.prototype? && 'itemView' of view.prototype
    
    action = () -> @showRegion(region, view, options)

    if viewIsCollection
      @listenTo @model, 'change', () -> @showRegion(region, view, options)
    else
      event = 'change' + (if options.regionModelAttribute? then ':' + options.regionModelAttribute)
      @listenTo @model, event, () -> @showRegion(region, view, options)
      @listenTo this, 'render', () -> @showRegion(region, view, options)

    @listenTo this, 'show', () -> @showRegion(region, view, options)

  showRegion: (region, view, options={}) ->
    debugger
    regionModel = if options.regionModelAttribute? then @model.get(options.regionModelAttribute) else @model
    
    unless regionModel? then return region.reset() 
    
    if view not instanceof Function
      typeAttribute = options.typeAttribute ? 'type'
      view = view[regionModel.get(typeAttribute)]

    viewOptions = if 'itemView' of view.prototype then {collection: regionModel} else {model: regionModel}

    region.show(new view(viewOptions))