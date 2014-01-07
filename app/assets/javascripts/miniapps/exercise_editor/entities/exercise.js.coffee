class ExerciseEditor.Exercise extends Backbone.AssociatedModel
  urlRoot: '/api/exercises'

  defaults:
    number: ''

  relations: [
    {
      type: Backbone.One,
      key: 'background',
      relatedModel: 'ExerciseEditor.Content',
    },
    {
      type: Backbone.Many,
      key: 'parts',
      relatedModel: 'ExerciseEditor.Part'
      collectionType: 'ExerciseEditor.Parts',
    }
  ]
