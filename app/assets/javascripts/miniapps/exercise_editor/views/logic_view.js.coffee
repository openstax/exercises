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
    'input @ui.numPermutationsInput': () -> Utils.enable(@ui.saveButton)

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
    @setStatus('Saving...')
    Utils.disable(@ui.saveButton)
    @model.set
      code: @editor.getValue()
      numPermutations: @ui.numPermutationsInput.val()
      variables: @ui.variablesInput.val()
    @model.regenerateOutputs()
    @model.save {}, 
      success: () => @clearStatus(), 
      error: () => Utils.enable(@ui.saveButton)

  setStatus: (text) ->
    @ui.status.html(text)

  clearStatus: () ->
    @setStatus('')