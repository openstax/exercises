class ExerciseEditor.QuestionView extends Marionette.Layout
  template: "question"

  tagName: "div"
  className: "question"

  regions:
    format: ".question-format"

  events:
    'click button.js-delete-question': "deleteQuestion"

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    formatView = 
      switch @model.get('type')
        when 'multiple_choice_question' then ExerciseEditor.MultipleChoiceQuestionView
        else throw 'Unknown question type'               

    @format.show(new formatView({model: @model}))

  blah: () ->
    formatView = 
      switch @model.get('type')
        when 'multiple_choice_question' then ExerciseEditor.MultipleChoiceQuestionView
        else throw 'Unknown question type'               

    @format.show(new formatView({model: @model}))

  onRender: () ->
    # alert 'here'
    @blah()

  deleteQuestion: () ->
    debugger
    @model.destroy(
      success: (model, response) ->
        debugger
        model.collection.remove(model)
    )