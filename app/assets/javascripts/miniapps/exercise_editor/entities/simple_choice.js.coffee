class ExerciseEditor.SimpleChoice extends Backbone.AssociatedModel
  urlRoot: '/api/simple_choices'

  relations: [
    {
      type: Backbone.One,
      key: 'content',
      relatedModel: 'ExerciseEditor.Content',
    }
  ]