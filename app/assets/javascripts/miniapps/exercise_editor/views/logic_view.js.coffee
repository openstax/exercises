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

  onDomRefresh: () ->
    @structuredVariablesInput = new ExerciseEditor.StructuredTextInput(
      @ui.variablesInput, 
      validation: 
        pattern: /^[\w,\s]*$/,
        message: "Variables must only contain underscores, letters, or numbers and must be separated by commas"
      parser: (value) -> value.replace(/[ \t\r\n]+/g,"").split(",")
    )

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
    # Check structured inputs before modifying model
    if !@structuredVariablesInput.isValid()
      @setStatus(@structuredVariablesInput.validate())
      return

    @model.set
      code: @editor.getValue()
      numPermutations: @ui.numPermutationsInput.val()
      variables: @structuredVariablesInput.val()

    if @model.isValid(true)
      @setStatus('Saving...')
      Utils.disable(@ui.saveButton)

      @model.regenerateOutputs()
        .then(
          () => @model.save {},
            success: () => @clearStatus(), 
            error: () => Utils.enable(@ui.saveButton)
        )

      # $(this)
      #   .queue((next) => @model.regenerateOutputs(next))
      #   .queue((next) => 
      #     @model.save {}, 
      #       success: () => @clearStatus(), 
      #       error: () => Utils.enable(@ui.saveButton))
    else
      msg = _.reduce(_.values(@model.validate()), (memo, error) -> memo + error + '. ')
      @setStatus(msg)

  setStatus: (text) ->
    @ui.status.html(text)

  clearStatus: () ->
    @setStatus('Ready')