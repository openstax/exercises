class ExerciseEditor.LogicInputView extends Marionette.ItemView
  template: "logic_input"

  tagName: "div"
  className: "logic-input"

  ui:
    textarea: 'textarea'
    numPermutationsInput: 'input.js-num-permutations'
    variablesInput: 'input.js-variables'
    currentPermutationInput: 'input.js-current-permutation'
    nextPermutationButton: '.js-next-permutation'
    prevPermutationButton: '.js-prev-permutation'

  events:
    # 'click @ui.saveButton': 'save'
    'input @ui.variablesInput': () -> @parent.enableSave() # could use triggers instead
    'input @ui.numPermutationsInput': () -> @parent.enableSave()
    'click @ui.nextPermutationButton': () -> @ui.nextPermutationButton.blur(); @model.moveToNextLogicOutput()
    'click @ui.prevPermutationButton': () -> @ui.prevPermutationButton.blur(); @model.moveToPrevLogicOutput()
    

  # TODO add events for changing the currentPermutationInput manually
  # TODO don't let users change permutation without saving the logic first
  #   (that new permutation won't be valid yet)

  initialize: () ->
    @listenTo @model, 'change:currentLogicOutputIndex', (model) => 
      @ui.currentPermutationInput.val(model.get('currentLogicOutputIndex'))
      @model.trigger('change')
    @parent = @options.parent

  onDomRefresh: () ->
    @structuredVariablesInput = new ExerciseEditor.StructuredTextInput(
      @ui.variablesInput, 
      validation: 
        pattern: /^[\w,\s]*$/,
        message: "Variables must only contain underscores, letters, or numbers and must be separated by commas"
      parser: (value) -> _.compact(value.replace(/[ \t\r\n]+/g,"").split(","))
    )

  onShow: () ->
    # Utils.disable(@ui.saveButton)

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

    @editor.on('change', (instance, changeObj) => @parent.enableSave())

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
      @parent.disableSave()

      @model.regenerateOutputs()
        .then(() => @model.save {},
          success: () => @clearStatus(), 
          error: () => @parent.enableSave()
        )
    else
      msg = _.reduce(_.values(@model.validate()), (memo, error) -> memo + error + '. ')
      @setStatus(msg)

  setStatus: (text) -> @parent.setStatus(text)

  clearStatus: () -> @parent.clearStatus()

