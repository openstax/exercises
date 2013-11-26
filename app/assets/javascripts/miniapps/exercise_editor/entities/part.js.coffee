class ExerciseEditor.Part extends Backbone.RelationalModel
  urlRoot: '/api/parts'

  defaults:
    position: -1,
    credit: -1

  relations: [
    {
      type: Backbone.HasOne,
      key: 'background',
      relatedModel: 'ExerciseEditor.Content',
      reverseRelation: {
        type: Backbone.HasOne
        key: 'part',
        includeInJSON: 'id'
      }
    }
  ]