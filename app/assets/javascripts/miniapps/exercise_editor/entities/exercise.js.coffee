class ExerciseEditor.Exercise extends Backbone.RelationalModel
  urlRoot: '/api/exercises'

  defaults:
    number: ''

  relations: [
    {
      type: Backbone.HasOne,
      key: 'background',
      relatedModel: 'ExerciseEditor.Content',
      reverseRelation: {
        type: Backbone.HasOne
        key: 'exercise',
        includeInJSON: false
      }
    },
    {
      type: Backbone.HasMany,
      key: 'parts',
      relatedModel: 'ExerciseEditor.Part'
      collectionType: 'ExerciseEditor.Parts',
      reverseRelation: {
        key: 'exercise',
        keySource: 'exercise_id',
        includeInJSON: 'id'
      }
    }
  ]

ExerciseEditor.Exercise.setup()