class ExerciseEditor.StructuredTextInput

  # Maybe wrap a backbone model and use backbone.validations

  constructor: (element, options={}) ->
    @element = element
    @options = options

  isValid: () ->
    !@validate()?

  validate: () ->
    # Run user specified code to check if @element.val() is valid
    if 'pattern' of @options.validation
      pattern = @options.validation.pattern
      if pattern instanceof RegExp
        if @element.val().match pattern
          return
        else
          return @options.validation.message || "There is an error in your input"
      else
        throw 'unknown pattern'
    else if 'function' of @options.validation
      throw 'not yet implemented'
    else
      throw 'unknown validation'

  val: () ->
    # Run user specified code to convert @element.val()
    @options.parser(@element.val())
    

