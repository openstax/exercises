class ExerciseEditor.LogicView extends Marionette.Layout
  template: "logic"

  tagName: "div"
  className: "logic"

  ui:
    saveButton: '.js-save-logic'
    # librariesButton: ".js-libraries-button"
    status: '.status'
    

  events:
    'click @ui.saveButton': 'save'
    # 'click @ui.librariesButton': () -> @libraries.$el.toggle()
    
  regions:
    input: '.logic-input'
    libraries: ".logic-library-list"

    # logic: '.exercise-logic'
    # background: '.exercise-background',
    # parts: '.exercise-parts'

  onShow: () ->
    Utils.disable(@ui.saveButton)

    @input.show(
      new ExerciseEditor.LogicInputView {
        model: @model
        parent: this
      }
    )

    @libraries.show(
      new ExerciseEditor.LogicLibraryListView {

      }
    )

    

  save: () ->
    @input.currentView.save()
    # # Check structured inputs before modifying model
    # if !@structuredVariablesInput.isValid()
    #   @setStatus(@structuredVariablesInput.validate())
    #   return

    # @model.set
    #   code: @editor.getValue()
    #   numPermutations: @ui.numPermutationsInput.val()
    #   variables: @structuredVariablesInput.val()

    # if @model.isValid(true)
    #   @setStatus('Saving...')
    #   Utils.disable(@ui.saveButton)

    #   @model.regenerateOutputs()
    #     .then(() => @model.save {},
    #       success: () => @clearStatus(), 
    #       error: () => Utils.enable(@ui.saveButton)
    #     )
    # else
    #   msg = _.reduce(_.values(@model.validate()), (memo, error) -> memo + error + '. ')
    #   @setStatus(msg)

  enableSave: () ->
    Utils.enable(@ui.saveButton)

  disableSave: () ->
    Utils.disable(@ui.saveButton)

  setStatus: (text) ->
    @ui.status.html(text)

  clearStatus: () ->
    @setStatus('Ready')
    