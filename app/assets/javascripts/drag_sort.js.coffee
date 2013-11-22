fixHelper = (e, ui) ->
  ui.children().each ->
    $(this).width $(this).width()
  ui
jQuery ->
  $('#queue_items').sortable
    helper: fixHelper
    axis: 'y'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
      $('tbody tr').each ->
        $(this).find(':input#queue_items__position').val($(this).closest('.queue_item').index()+1)