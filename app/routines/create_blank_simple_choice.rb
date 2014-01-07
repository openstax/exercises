class CreateBlankSimpleChoice

  lev_routine

protected

  def exec(question)
    if !question.format.is_a?(MultipleChoiceQuestion)
      fatal_error(code: :question_is_not_multiple_choice, 
                  message: 'Can only create a simple choice for a multiple choice question') 
    end

    choice = SimpleChoice.create do |choice|
      choice.multiple_choice_question = question.format
      choice.content = Content.new
    end

    outputs[:simple_choice] = choice
    transfer_errors_from(choice, {type: :verbatim})
  end

end