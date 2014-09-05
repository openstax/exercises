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
  
  ex.fetch
    success: () ->
      ExerciseEditor.main.show(new ExerciseEditor.ExerciseView({model: ex}))
  
  ExerciseEditor.tempEx = ex