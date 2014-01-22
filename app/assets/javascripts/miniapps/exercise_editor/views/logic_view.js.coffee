class ExerciseEditor.LogicView extends Marionette.ItemView
  template: "logic"

  tagName: "div"
  className: "logic"

  ui:
    textarea: 'textarea'
    saveButton: '.js-save-logic'
    numPermutationsInput: 'input.js-num-permutations'
    variablesInput: 'input.js-variables'
    status: '.status'

  events:
    'click @ui.saveButton': 'save'
    'input @ui.variablesInput': () -> Utils.enable(@ui.saveButton)

  onShow: () ->
    Utils.disable(@ui.saveButton)

    @editor = CodeMirror.fromTextArea(
      @ui.textarea.get(0), 
      {
        mode: 'javascript',
        lineNumbers: true,
        matchBrackets: true,
        gutters: ["CodeMirror-lint-markers"],
        lint: true
      }
    )

    @editor.on('change', (instance, changeObj) => Utils.enable(@ui.saveButton))

  save: () ->
    @setStatus('Saving code...')
    @model.save(
      {
        code: @editor.getValue()
        numPermutations: @ui.numPermutationsInput.val()
        variables: @ui.variablesInput.val()
      }, 
      {
        success: () => 
          Utils.disable(@ui.saveButton)
          @setStatus('Saving permutations...')
          @model.regenerateOutputs()
      }
    )

  setStatus: (text) ->
    @ui.status.html(text)

  clearStatus: () ->
    @setStatus('')