class ExerciseEditor.LogicView extends Marionette.ItemView
  template: "logic"

  tagName: "div"
  className: "logic"

  ui:
    textarea: 'textarea'

  onShow: () ->
    CodeMirror.fromTextArea(
      @ui.textarea.get(0), 
      {
        mode: 'javascript',
        lineNumbers: true,
        matchBrackets: true,
        gutters: ["CodeMirror-lint-markers"],
        lint: true
      }
    )