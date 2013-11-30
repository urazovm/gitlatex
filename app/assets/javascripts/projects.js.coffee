# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.repo .btn', () ->
  $(this).siblings('.current').removeClass 'current'
  $(this).addClass 'current'
$(document).on 'focus', '.repo input', () ->
  $(this).select()
$(document).on 'mouseup', '.repo input', () ->
  false
