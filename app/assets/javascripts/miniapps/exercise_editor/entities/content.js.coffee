class ExerciseEditor.Content extends Backbone.AssociatedModel
  urlRoot: '/api/contents'

  defaults:
    markup: '',
    html: ''

  container: () ->
    @parents[0]

  save: (key, val, options) ->
    @container().save(key, val, options)

  connectToLogic: (logic) ->
    @listenToBulkChange logic, 'logic_outputs', {runActionIfPresent: true}, () => @logicUpdated logic

  logicUpdated: (logic) ->
    variables = logic.get('variables')
    values = logic.currentLogicOutput()?.values()

    if !values? then return

    html = @get('markup')
    _.each variables, (variable, index) =>
      value = values[index]
      html = html.replace('=' + variable + '=', value)

    @set('html', html)
