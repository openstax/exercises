class ExerciseEditor.Logic extends Backbone.AssociatedModel
  urlRoot: '/api/logics'

  defaults:
    code: '',
    variables: '',
    numPermutations: 100

  relations: [
    {
      type: Backbone.Many,
      key: 'logic_outputs',
      relatedModel: 'ExerciseEditor.LogicOutput',
    }
  ]

  validation:
    numPermutations:
      range: [1, 500]
      required: true
    variables:
      pattern: /[\w,\s]/


  # run: () ->
  #   # Create a new logic closure, copy in relevant library code, set the seed,
  #   # copy in the logic code, return the 
  #   @get('logic_outputs')


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

  setOutputs: () ->


  runForSeed: (seed) ->

    # Math.seedrandom(seed)

    do () =>
      eval @get('code')

    _.collect @variables(), (variable) -> eval(variable)
