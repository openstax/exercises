# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Exercise ||= {}

window.Exercise.hide_embargo_form = ->
  $('.embargo_form').hide()
  $('.embargo_link').show()

window.Exercise.show_embargo_form = ->
  $('.embargo_form').show()
  $('.embargo_link').hide()
