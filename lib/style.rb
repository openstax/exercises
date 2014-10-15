module Style

  MULTIPLE_CHOICE   = 'multiple_choice'
  MULTIPLE_SELECT   = 'multiple_select'
  SHORT_ANSWER      = 'short_answer'
  FILL_IN_THE_BLANK = 'fill_in_the_blank'
  POINT_AND_CLICK   = 'point_and_click'
  MATCHING          = 'matching'
  SORTING           = 'sorting'
  FREE_RESPONSE     = 'free_response'
  DRAWING           = 'drawing'

  def self.all
    [MULTIPLE_CHOICE, MULTIPLE_SELECT, SHORT_ANSWER, FILL_IN_THE_BLANK,
     POINT_AND_CLICK, MATCHING, SORTING, FREE_RESPONSE, DRAWING]
  end

end
