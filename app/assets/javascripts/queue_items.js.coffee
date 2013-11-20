jQuery ->
  $('#queue_items').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
      $('tbody tr').each ->
        $(this).find(':input#queue_items__position').val($(this).closest('.queue_item').index()+1)