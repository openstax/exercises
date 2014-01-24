class ExerciseEditor.Logic extends Backbone.AssociatedModel
  urlRoot: '/api/logics'

  relations: [
    {
      type: Backbone.Many,
      key: 'logic_outputs',
      relatedModel: 'ExerciseEditor.LogicOutput',
    }
  ]

  defaults:
    code: '',
    variables: '',
    numPermutations: 100

  validation:
    numPermutations:
      range: [1, 500]
      required: true
    variables:
      pattern: /[\w,\s]/


  initialize: () ->
    logic_outputs = @get('logic_outputs')
    @set('numPermutations', logic_outputs.length)
    if logic_outputs.length > 0 then @set('currentSeed', @get('logic_outputs').at(0).get('seed'))

  currentLogicOutput: () ->
    if !@get('currentSeed')? then return undefined
    @get('logic_outputs').find (lo) => lo.get('seed') == @get('currentSeed')  

  # Return the array of seeds currently in use.  If there are fewer seeds
  # than specified in numPermutations, add new ones.  If there are more than
  # needed, eliminate the ones at the end.
  getCleanSeeds: () ->
    seeds = @get('logic_outputs').pluck('seed')
    numMissingSeeds = @get('numPermutations') - seeds.length
    if numMissingSeeds > 0
      nextSeed = if seeds.length == 0 then 0 else seeds[seeds.length-1]+1
      seeds = seeds.concat([nextSeed..nextSeed+numMissingSeeds-1])
    else if numMissingSeeds < 0
      seeds = seeds.slice(0, numMissingSeeds)
    seeds

    # doesn't take into account seeds at end of array that were deleted, could store 
    # a next seed in Logic

  variables: () ->
    @get('variables').replace(/[ \t\r\n]+/g,"").split(",")

  regenerateOutputs: () ->
    seeds = @getCleanSeeds()

    newOutputs = _.collect seeds, (seed) => 
      values = @runForSeed(seed)
      logicOutput = new ExerciseEditor.LogicOutput({seed: seed, values: JSON.stringify(values)})

    @get('logic_outputs').reset(newOutputs)

  runForSeed: (seed) ->

    # Math.seedrandom(seed)

    do () =>
      eval @get('code')

    # Return the values of the "available variables".  Only allow strings and numbers.
    # TODO on server side escape javascript
    
    outputs = _.collect @variables(), (variable) ->
      value = window[variable]
      if value instanceof Raphael
        value = value.toSVG()
      else if _.isNumber(value) or _.isString(value)
        value = value
      else
        value = nil

    _.compact(outputs)

