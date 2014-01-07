@Utils = do () ->

  disable: (jq) ->
    jq.attr('disabled', 'disabled')
    jq.attr('aria-disabled', true)

  enable: (jq) ->
    jq.removeAttr('disabled')
    jq.removeAttr('aria-disabled')


  grayOut: (jq) ->
    jq.addClass('gray-out')

  unGrayOut: (jq) ->
    jq.removeClass('gray-out')
