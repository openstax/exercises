class BuildSimpleExercise

  lev_routine

  protected

  def exec(options = {})
    format = Format.find_by(name: options[:format] || 'multiple_choice')
    answer = Answer.new(content: options[:answer] || 'Answer')
    question = Question.new(stem: options[:question] || 'Question?', answers: [answer])
    question.formattings << Formatting.new(formattable: question, format: format)
    part = Part.new(background: options[:part] || nil, questions: [question])
    exercise = Exercise.new(background: options[:exercise] || nil, parts: [part])
    outputs[:exercise] = exercise
  end

end
