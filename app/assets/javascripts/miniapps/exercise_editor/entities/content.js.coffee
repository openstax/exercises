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
    @logicUpdated logic
    @listenTo logic.get('logic_outputs'), 'reset', () => @logicUpdated logic

  logicUpdated: (logic) ->
    variables = logic.variables()
    values = logic.currentLogicOutput().values()

    html = @get('markup')
    _.each variables, (variable, index) =>
      value = values[index]
      html = html.replace('=' + variable + '=', value)

    @set('html', html)
