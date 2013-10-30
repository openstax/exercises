Ui = do () ->

  disableButton: (selector) ->
    $(selector).attr('disabled', 'disabled')
    $(selector).addClass('ui-state-disabled ui-button-disabled')
    $(selector).attr('aria-disabled', true)

  enableButton: (selector) ->
    $(selector).removeAttr('disabled')
    $(selector).removeAttr('aria-disabled')
    $(selector).removeClass('ui-state-disabled ui-button-disabled')
    $(selector).button()

  renderAndOpenDialog: (html_id, content, modal_options = {}) ->
    if $('#' + html_id).exists() then $('#' + html_id).remove()
    $("#application-body").append(content)
    $('#' + html_id).modal(modal_options).center()

(exports = this).Exercises ?= {}
exports.Exercises.Ui = Ui