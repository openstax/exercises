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
    variables: [],
    numPermutations: 100


  validation:
    numPermutations:
      range: [1, 500]
      required: true
    variables: (variables, attr, computedState) -> 
      if !_.isArray(variables) then return "Variables must be an array"
      if !_.every(variables, (vv) -> _.isString(vv)) then return "Variables must be strings"

  constructor: () ->
    @listenTo this, 'change:logic_outputs', () ->
      logic_outputs = @get('logic_outputs')
      @set('numPermutations', logic_outputs.length)
      if logic_outputs.length > 0 then @set('currentSeed', logic_outputs.at(0).get('seed'))
    super


# jim = sandbox({js: 'x = function (y) { return y*2}'})
# <iframe seamless sandbox=​"allow-scripts allow-forms allow-top-navigation allow-same-origin">​…​</iframe>​
# jim.contentWindow.x(3)
# 6

  initialize: () ->
    @sandbox = sandbox({js: 'yy = 42; console.log("howdy")'}) # TODO initialize with logic libraries
    console.log this.sandbox.contentWindow['yy']

    @libraryDigest = ""
    @listenTo this, 'change:library_version_ids', @refreshLibraries

  refreshLibraries: () ->
    # Set some flag that we are not ready to run the code
    # like librariesSynched = false
    digest = new ExerciseEditor.LibraryVersionDigest({ids: @get('library_version_ids')})
    digest.fetch(
      success: (model) ->
        @libraryDigest = model.get('code')
        # Set flag that we are ready to run the code
    )

  currentLogicOutput: () ->
    if !@get('currentSeed')? then return undefined
    @get('logic_outputs').find (lo) => lo.get('seed') == @get('currentSeed')  

  # Return the array of seeds currently in use.  If there are fewer seeds
  # than specified in numPermutations, add new ones.  If there are more than
  # needed, eliminate the ones at the end.
  getCleanSeeds: () ->
    seeds = @get('logic_outputs')?.pluck('seed') || []
    numMissingSeeds = @get('numPermutations') - seeds.length
    if numMissingSeeds > 0
      nextSeed = if seeds.length == 0 then 0 else seeds[seeds.length-1]+1
      seeds = seeds.concat([nextSeed..nextSeed+numMissingSeeds-1])
    else if numMissingSeeds < 0
      seeds = seeds.slice(0, numMissingSeeds)
    seeds

    # TODO doesn't take into account seeds at end of array that were deleted, could store 
    # a next seed in Logic

  regenerateOutputs: () ->
    # setup a new sandbox here, wrap logic code in a function that can be called with different seeds
    # delete old sandbox so don't pile up a zillion iframes

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

    outputs = _.collect @get('variables'), (variable) ->
      value = window[variable]
      if value instanceof Raphael
        value = value.toSVG()
      else if _.isNumber(value) or _.isString(value)
        value = value
      else
        value = nil

    _.compact(outputs)

