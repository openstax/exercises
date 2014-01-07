ExerciseEditor.module(
  "Store", 
  (Store, App, Backbone, Marionette, $, _) ->

    theStore = {}
    pendingModelActions = {}

    Store.addModel = (model) ->
      className = if model.constructor.name? then model.constructor.name else model.constructor.toString().match(/^function\s(.+)\(/)[1]
      id = model.get('id')

      theStore[className] ?= {}

      if theStore[className][id]? 
        if theStore[className][id].cid == model.cid then return
        throw "model already exists in store"

      theStore[className][id] = model

      processPendingModelActions(className, id)

    Store.onModelAvailable = (className, id, action) ->
      getPendingModelActions(className, id).push(action)
      processPendingModelActions(className, id)

    getPendingModelActions = (className, id) ->
      pendingModelActions[className] ?= {}
      pendingModelActions[className][id] ?= []

    processPendingModelActions = (className, id) ->
      model = theStore[className]?[id]
      return if not model?
      actions = getPendingModelActions(className, id)
      _.each(actions, (action) -> action(model))
      actions = []


)