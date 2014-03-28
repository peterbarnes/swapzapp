$(document).ready ->
  $(".sidebar-menu .dropdown-toggle").click (event) ->
    event.preventDefault()
    item = $(this).parent()
    item.toggleClass("active")
    if item.hasClass("active")
      item.find(".submenu").slideDown("fast")
    else
      item.find(".submenu").slideUp("fast")
  $(".sidebar-menu li.active").find(".submenu").show()
  
  if $.cookie('swapz_menu')
    $('.content').addClass('full').addClass('notransition')
    $('.sidebar-nav').addClass('hide')
    
  $('.menu').click (event) ->
    event.preventDefault()
    $('.content').removeClass('notransition').toggleClass('full')
    $('.sidebar-nav').toggleClass('hide')
    if $('.content').hasClass('full')
      $.cookie('swapz_menu', true, { path: '/' })
    else
      $.removeCookie('swapz_menu', { path: '/' })
        