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

  initialize: () ->
    @listenTo this, 'change:library_version_ids', () => @libraryDigest = null

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
    # Need to wait for refreshLibraries to finish before setting up and running the
    # code in the sandbox. Note that the last call to 'then' returns a Promise to this
    # method's caller so it too can be put into a deferred then chain.

    @refreshLibraries()
      .then(() =>
        @setupSandbox()
        seeds = @getCleanSeeds()

        newOutputs = _.collect seeds, (seed) => 
          values = @runForSeed(seed)
          logicOutput = new ExerciseEditor.LogicOutput({seed: seed, values: JSON.stringify(values)})

        @get('logic_outputs').reset(newOutputs))

  refreshLibraries: () ->    
    def = new $.Deferred()

    if @libraryDigest? 
      def.resolve()
    else
      @libraryDigest = new ExerciseEditor.LibraryVersionDigest({ids: @get('library_version_ids')})
      @libraryDigest.fetch(success: (model) -> 
        @libraryDigest = model.get('code')
        def.resolve()
      )

    def.promise()

  setupSandbox: (next) ->
    # Set up a new sandbox with the library content, the user's code, and the glue logic
    # to make everything run.  The user's code is placed into a function so it can be
    # called over and over later (for each seed).  Before making the new sandbox, delete
    # the old one so that we don't have a zillion iframes piling up.

    code = @libraryDigest.get('code') + 

           'iterationOutputs = {};'+
           '; runIteration = function (seed) { iterationOutputs = {}; Math.seedrandom(seed); ' + 
           @get('code') + "\n" +

           (_.collect @get('variables'), (variable) -> 
             "if (typeof " + variable + ".toExercisesNormalization === 'function') { " + 
             variable + " = " + variable + ".toExercisesNormalization(); };\n
             iterationOutputs['" + variable + "'] = " + variable + ";").join("\n") +

           '}'

    if @sandbox? then @sandbox.remove()    
    @sandbox = sandbox({js: code})

  runForSeed: (seed) ->    
    @sandbox.contentWindow.runIteration(seed);

    # # Return the values of the "available variables".  Only allow strings and numbers.
    # # TODO on server side escape javascript

    outputs = _.collect @get('variables'), (variable) =>
      value = @sandbox.contentWindow['iterationOutputs'][variable]
      if !(_.isNumber(value) or _.isString(value)) then value = nil
      value

    _.compact(outputs)

