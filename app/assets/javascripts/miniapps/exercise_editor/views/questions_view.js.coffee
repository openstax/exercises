class ExerciseEditor.QuestionsView extends Marionette.CollectionView
  getItemView: (item) ->
    switch item.get('type')
      when 'multiple_choice_question' then ExerciseEditor.MultipleChoiceQuestionView
      else null # <-- getting here


# the item above is just a Question so it isn't working