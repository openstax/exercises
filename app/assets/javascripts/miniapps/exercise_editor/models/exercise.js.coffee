class ExerciseEditor.Exercise extends Backbone.RelationalModel
  urlRoot: '/api/exercises'

  defaults:
    number: '',
    id: ''

  relations: [
    {
      type: Backbone.HasOne,
      key: 'background',
      relatedModel: 'ExerciseEditor.Content',
      reverseRelation: {
        type: Backbone.HasOne
        key: 'exercise',
        includeInJSON: 'id'
      }
    }
  ]
