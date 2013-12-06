class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  tagName: "div"
  className: "content"

  ui: 
    input: 'textarea',
    output: '.output'

  events:
    'click .output': 'edit'
    'focusout textarea': 'save'

  initialize: () ->
    @listenTo @model, 'sync', @render
    @listenTo @model.container(), 'sync', @render

  edit: () ->
    @ui.input.height(Math.max(@ui.output.height(), 60))
    @ui.input.width(@ui.output.width())

    @ui.output.toggle()
    @ui.input.toggle().focus()

    # Not super efficient to do this every time, but can't get it to work otherwise
    @ui.input.writemaths()

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
      
    
