class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  ui: 
    input: 'textarea',
    output: '.output'

  events:
    'dblclick .output': 'edit'
    'focusout textarea': 'save'

  initialize: () ->
    @listenTo @model, 'sync', @render
    @listenTo @model.container(), 'sync', @render

  edit: () ->
    @ui.input.writemaths()
    @ui.input.height(Math.max(@ui.output.height(), 60))
    @ui.input.width(@ui.output.width())

    @ui.output.toggle()
    @ui.input.toggle().focus()

  onRender: () ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub,@ui.output.get()]);
    
  save: () ->
    @model.set('markup', @ui.input.val())
    Utils.disable(@ui.input)
    Utils.grayOut(@ui.input)
    @model.save {}, {
      success: (model, response, options) =>
        model.fetch()
      error: (model, response, options) =>
        Utils.enable(@ui.input)
        Utils.unGrayOut(@ui.input)
    }
      
    
