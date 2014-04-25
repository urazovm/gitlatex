# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ajax:before', '.project .activation', ->
  $(this).button 'loading'
$(document).on 'ajax:complete', '.project .activation', (xhr, status) ->
  $(this).button 'reset'
