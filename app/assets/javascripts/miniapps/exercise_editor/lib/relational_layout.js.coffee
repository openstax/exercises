# When using regions in a layout, it can happen (esp with Backbone Relational) that a region is not
# updated with changes to a model.  This is particularly true when creating new instances of models.
# In such a case (e.g. calling 'create' on a collection, passing a new model with nested models),
# the region will be shown but when the create API response comes back nested models tend to get
# blown away leaving regions with views attached to orphaned model instances.  The code below is 
# an attemp to keep regions updated when these kinds of changes happen.

_.extend Marionette.Layout.prototype,
  # 
  # region:  
  #   a Marionette.Region object
  # view: 
  #   either a Marionette.View class, e.g. MyApp.MyView, or a hash of labeled Marionette.View 
  #   classes, e.g. { 'monkey': MyApp.MonkeyView, 'tiger': MyApp.TigerView }.  The latter form
  #   is used when the view depends on some characteristic of the model to be rendered, e.g. its
  #   type.
  # options:
  #   regionModelAttribute:
  #     if null, the parent layout's model is shown.  If provided, the parent layout's 
  #     model.get(regionModelAttribute) is shown.
  #   typeAttribute: the attribute in the model to use to pick a view class when 'view' is a 
  #     hash.  'type' is the default.
  #
  maintainRegion: (region, view, options={}) ->

    # This is what all the listeners will call below
    action = () -> @showRegion(region, view, options)

    logger = (object, event) => @listenTo(object, event, () -> debugger; console.log(object.__proto__.constructor.name + ": " + object.cid  + "(" + region.el + ")" +  "       " + event))

    # If the view is a collection, we'll want to reshow the region whenever there
    # is a change (otherwise, our collection can get replaced (especially for new @models
    # and our view will end up with an orphaned collection))
    viewIsCollection = view.prototype? && 'itemView' of view.prototype

    if viewIsCollection
      logger(@model, 'change')
      @listenTo @model, 'change', action
    else
      # If we're maintaining a region for an attribute of @model, watch for changes on it.
      # If the @model itself changes, also reshow the region
      event = 'change' + (if options.regionModelAttribute? then ':' + options.regionModelAttribute)
      logger(@model, event)
      @listenTo @model, event, action
      logger(this, 'render')
      @listenTo this, 'render', action
      

    # This is the first showing
    logger(this, 'show')
    @listenTo this, 'show', action
    

  showRegion: (region, view, options={}) ->
    # console.log(region)
    # Get the model we're to show in the region
    regionModel = if options.regionModelAttribute? then @model.get(options.regionModelAttribute) else @model
    
    # Bail if there is no model (could have been destroyed)
    unless regionModel? then return region.reset() 
    
    # 'view' can be a hash of views, each for a different type.  If that is the case,
    # select the appropriate view class using the specified (or default) type attribute.
    if view not instanceof Function
      typeAttribute = options.typeAttribute ? 'type'
      view = view[regionModel.get(typeAttribute)]

    # If we're rendering a collection, need to pass collection: ..., otherwise model: ...
    viewOptions = if 'itemView' of view.prototype then {collection: regionModel} else {model: regionModel}

    # Show the view in the region
    region.show(new view(viewOptions))