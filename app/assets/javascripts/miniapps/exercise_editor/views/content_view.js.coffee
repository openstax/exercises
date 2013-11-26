class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  ui: 
    input: 'textarea',
    output: '.output'

  events:
    'dblclick .output': 'edit'
    'focusout textarea': 'save'

  initialize: () ->
    this.listenTo this.model, 'change', this.render

  edit: () ->
    @ui.output.toggle()
    @ui.input.toggle().focus()
    

  save: () ->
    @ui.input.toggle()
    @ui.output.toggle()
    this.model.set('markup', @ui.input.val())
    this.model.save()
