class ExerciseEditor.Exercise extends Backbone.AssociatedModel
  urlRoot: '/api/exercises'

  relations: [
    {
      type: Backbone.One,
      key: 'logic',
      relatedModel: 'ExerciseEditor.Logic'
    },
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

  defaults:
    number: '',
    logic: null
