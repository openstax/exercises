class ExerciseEditor.Question extends Backbone.RelationalModel
  urlRoot: '/api/questions'

  subModelTypes: 
    'multiple_choice_question': 'ExerciseEditor.MultipleChoiceQuestion'


  initialize: () ->
    @listenTo this, 'sync', () -> console.log('synchec question ' + @get('cid'))

ExerciseEditor.Question.setup()