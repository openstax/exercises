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
        includeInJSON: false
      }
    },
    {
      type: Backbone.HasMany,
      key: 'questions',
      relatedModel: 'ExerciseEditor.Question'
      collectionType: 'ExerciseEditor.Questions',
      reverseRelation: {
        key: 'part',
        keySource: 'part_id',
        includeInJSON: 'id'
      }
    }
  ]


  initialize: () ->
    @listenTo this, 'sync', () -> console.log('synchec part ' + @get('cid'))

ExerciseEditor.Part.setup()