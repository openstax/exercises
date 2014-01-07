module ExercisesHelper
  def quickview_link(exercise)
    link_to(exercise.summary, quickview_exercise_path(exercise), :remote => true)
  end

  def exercise_embargo_status(exercise)
    if exercise.is_published?
      if exercise.embargoed_until.nil?
        'This exercise was not embargoed.'
      else
        if exercise.embargoed_until >= Date.current
          (exercise.only_embargo_solutions ? 'Solutions for this exercise are' : 'This exercise is') +
          " embargoed until #{exercise.embargoed_until}."
        else
          (exercise.only_embargo_solutions ? 'Solution' : 'Exercise') +
          " embargo expired on #{exercise.embargoed_until}."
        end
      end
    else
      if exercise.embargo_days == 0
        'This exercise will not be embargoed.'
      else
        (exercise.only_embargo_solutions ? 'Solutions for this' : 'This') +
        " exercise will be embargoed until #{Date.current + exercise.embargo_days.days} if published today."
      end
    end
  end
end

