@ExerciseEditor = new Backbone.Marionette.Application

ExerciseEditor.addInitializer (options) ->
  ExerciseEditor.startOptions = options

ExerciseEditor.addRegions 
  main: '.exercise-edit-app'

ExerciseEditor.Router = Marionette.AppRouter.extend
  appRoutes: {}




ExerciseEditor.on 'initialize:after', () ->
  Backbone.history.start
  ex = new ExerciseEditor.Exercise id: ExerciseEditor.startOptions.exerciseId
  
  
  ExerciseEditor.main.show(new ExerciseEditor.ExerciseView({model: ex}))
  ex.fetch
    success: () ->
      # ExerciseEditor.main.show(new ExerciseEditor.ExerciseView({model: ex}))
      console.log(ex.attributes)
  ExerciseEditor.tempEx = ex