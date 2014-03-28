$(document).ready ->
  $('a.print').click (event) ->
    _window = window.open($(this).data('url'))
    _window.focus()
    _window.print()
    event.preventDefault()