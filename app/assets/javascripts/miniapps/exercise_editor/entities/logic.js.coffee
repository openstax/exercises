class ExerciseEditor.Logic extends Backbone.AssociatedModel
  urlRoot: '/api/logics'

  defaults:
    code: '',
    variables: ''