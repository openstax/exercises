class CreateBlankPart

  lev_routine

protected

  def exec(exercise)
    part = Part.create do |part|
      part.exercise = exercise
      part.background = Content.new
    end

    outputs[:part] = part
    transfer_errors_from(part, {type: :verbatim})
  end

end