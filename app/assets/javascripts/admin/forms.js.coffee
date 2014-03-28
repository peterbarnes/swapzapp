$(document).ready ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).closest('.panel').find('input[type=hidden].destroy').val('1')
    $(this).closest('.panel').hide()
    event.preventDefault()
        
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).closest('fieldset').find('.fields').append($(this).data('fields').replace(regexp, time))
    event.preventDefault()
    
  $('form').on 'change', '.currency input[type=number]', (event) ->
    val = $(this).val()
    $(this).prev('input[type=hidden]').val(parseInt(val * 100))
  
  $('form').on 'click', '.adjustment a', (event) ->
    type = $(this).attr('data-type')
    if type == 'percent'
      $(this).html('$')
      $(this).attr('data-type', 'currency')
      $(this).parent().siblings('input[type=hidden]').val(false)
    if type == 'currency'
      $(this).html('%')
      $(this).attr('data-type', 'percent')
      $(this).parent().siblings('input[type=hidden]').val(true)
    event.preventDefault()
    
  $('select.template').change () ->
    if ($(this).val().length > 0) 
      $('iframe').attr('src', $('iframe').data('url') + '/?template=' + $(this).val())
      $('a.print').data('url', $('iframe').data('url') + '/?template=' + $(this).val() + '&print=true')
    else
      $('iframe').attr('src', $('iframe').data('url'))
      $('a.print').data('url', $('iframe').data('url') + '/?print=true')
      
  $('a.save').click (event) ->
    $('form').submit()
    event.preventDefault()
    
  $('textarea.editor').each () ->
    textarea = $(this)
    
    mode = textarea.data('editor')
    read_only = textarea.data('read-only')
    
    editor = ace.edit('editor')
    editor.renderer.setShowGutter(false)
    editor.setTheme("ace/theme/eclipse")
    editor.getSession().setUseSoftTabs(true)
    editor.setShowPrintMargin(false)
    editor.renderer.setShowGutter(true)
    
    unless read_only == undefined
      editor.setReadOnly(true)
    
    textarea.hide()
    
    editor.getSession().setValue(textarea.val())
    editor.getSession().on 'change', () ->
      textarea.val(editor.getSession().getValue())