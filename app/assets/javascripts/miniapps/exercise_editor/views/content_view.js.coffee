class ExerciseEditor.ContentView extends Marionette.ItemView
  template: "content"

  tagName: "div"
  className: "content"

  ui: 
    input: 'textarea',
    output: '.output'

  events:
    'click .output': 'edit'

  initialize: () ->
    @listenTo @model, 'sync', @render
    @listenTo @model.container(), 'sync', @render

  edit: () ->
    @ui.input.height(Math.max(@ui.output.height(), 60))
    @ui.input.width(@ui.output.width())

    @ui.output.toggle()
    @ui.input.show().focus()

    # Not super efficient to do this every time, but can't get it to work otherwise
    @ui.input.tinymce
      toolbar: 'bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent blockquote | link image code | undo redo | save'
      menu: {}
      view: this
      init_instance_callback: (ed) ->
        ed.settings.view.$el.writemaths({iFrame: true})
      setup: (ed) ->    
        ed.addButton('save', {
          title: 'Save'
          icon: 'save'
          onclick: () -> ed.settings.view.save()
        })
      statusbar: false

  onRender: () ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub,@ui.output.get()]);
    
  save: () ->
    @model.set('markup', @ui.input.tinymce().getContent())
    @model.save {}, {
      success: (model, response, options) =>
        model.fetch()
      error: (model, response, options) =>
    }
      
    
