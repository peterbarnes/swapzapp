$(document).ready ->
  $('iframe').load ->
    $(this).height($(this).contents().height())