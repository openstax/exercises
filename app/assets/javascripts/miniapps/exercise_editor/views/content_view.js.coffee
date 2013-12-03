class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  ui: 
    input: 'textarea',
    output: '.output'

  events:
    'dblclick .output': 'edit'
    'focusout textarea': 'save'

  initialize: () ->
    @listenTo @model, 'change', @render
    @listenTo @model.container(), 'change', @render

  edit: () ->
    @ui.output.toggle()
    @ui.input.toggle().focus()
    

  save: () ->
    @ui.input.toggle()
    @ui.output.toggle()
    @model.set('markup', @ui.input.val())
    @model.save {}, {
      success: (model, response, options) ->
        model.fetch()
    }
      
    
