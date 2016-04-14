module Style

  MULTIPLE_CHOICE   = 'multiple-choice'
  MULTIPLE_SELECT   = 'multiple-select'
  SHORT_ANSWER      = 'short-answer'
  FILL_IN_THE_BLANK = 'fill-in-the-blank'
  POINT_AND_CLICK   = 'point-and-click'
  MATCHING          = 'matching'
  SORTING           = 'sorting'
  FREE_RESPONSE     = 'free-response'
  DRAWING           = 'drawing'
  TRUE_FALSE        = 'true-false'

  def self.all
    [MULTIPLE_CHOICE, MULTIPLE_SELECT, SHORT_ANSWER, FILL_IN_THE_BLANK,
     POINT_AND_CLICK, MATCHING, SORTING, FREE_RESPONSE, DRAWING, TRUE_FALSE]
  end

end
