# Sometimes you want to run an action for when the entire contents of contained
# collection change.  This happens when the collection is replaced and when 
# the collection is reset.  But if you want to listen for a reset the collection
# has to already be defined (which it may not be yet).  This listenTo variant
# pays attention to when the collection is changed outright and when it is reset.
# If the collection is not defined when this function is called, it will attach
# the reset listener when it becomes defined.
#
# options:
#   runActionIfPresent: if true, runs the provided action when this function is
#     called if the specified collection is already present (defaults to false)

extension = 
  listenToBulkChange: (container, collectionName, options, action) ->
    _.defaults options, {
      runActionIfPresent: false
    }

    @listenTo container, 'change:' + collectionName, (model, collection, options) ->
      action(collection, options)
      @listenTo container.get(collectionName), 'reset', (collection, options) -> action(collection, options)

    if container.get(collectionName)?
      if options.runActionIfPresent then action(container.get(collectionName))
      @listenTo container.get(collectionName), 'reset', (collection, options) -> action(collection, options)

_.extend Backbone.Model.prototype, extension

# 

#@listenToChangeOrReset logic, 'logic_outputs', (collection, value, options) => @logicUpdated logic