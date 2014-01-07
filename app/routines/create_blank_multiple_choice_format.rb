class CreateBlankMultipleChoiceFormat

  lev_routine

protected

  def exec
    outputs[:format] = MultipleChoiceQuestion.create do |mpq|
      mpq.stem = Content.new
    end
  end

end