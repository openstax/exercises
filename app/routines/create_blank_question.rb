class CreateBlankQuestion

  lev_routine

  uses_routine CreateBlankMultipleChoiceFormat,
               translations: { outputs: {type: :verbatim} }

protected

  def exec(part, type)
    case type
    when 'multiple_choice_question'
      run(CreateBlankMultipleChoiceFormat)
    else
      fatal_error(code: :unknown_question_type)
    end; debugger

    question = Question.create do |question|
      question.part = part
      question.format = outputs[:format]
    end

    outputs[:question] = question
    transfer_errors_from(question, {type: :verbatim})
  end
end