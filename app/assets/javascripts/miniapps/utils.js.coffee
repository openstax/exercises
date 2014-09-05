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

# http://stackoverflow.com/a/5306832/1664216
Array.prototype.move = (old_index, new_index) ->
  if new_index >= this.length
    k = new_index - this.length
    while ((k--) + 1) 
      this.push(undefined)

  this.splice(new_index, 0, this.splice(old_index, 1)[0])