class CreateBlankComboChoice

  lev_routine

protected

  def exec(question)
    if !question.format.is_a?(MultipleChoiceQuestion)
      fatal_error(code: :question_is_not_multiple_choice, 
                  message: 'Can only create a combo choice for a multiple choice question') 
    end

    choice = ComboChoice.create do |choice|
      choice.multiple_choice_question = question.format
    end

    outputs[:combo_choice] = choice
    transfer_errors_from(choice, {type: :verbatim})
  end

end