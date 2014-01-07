class ExerciseEditor.SimpleChoiceView extends Marionette.Layout
  template: "simple_choice"

  tagName: "div"
  className: "simple-choice"

  regions:
    content: ".simple-choice-content"

  events:
    'click button.js-delete-choice': "delete"
    # 'mouseenter': () -> console.log 'sc mouseenter'
    # 'mouseleave': () -> console.log 'sc mouseleave'
    # 'focusin': () -> console.log 'sc focusin'
    # 'focusout': () -> console.log 'sc focusout'
    # 'focus': () -> console.log 'sc focus'

  initialize: () ->
    @listenTo @model, 'change', @render

  onShow: () ->
    @content.show(new ExerciseEditor.ContentView({model: @model.get('content')}))

  ### Controller Methods ###

  delete: () -> @model.destroy()
