jQuery ->
  $(".rateit.rateit-active").bind "rated reset", ->
    ri = $(this)
    $.post($(this).data('update-url'),
        queue_item_id: $(this).data("queueitemid"),
        rating: $(this).rateit("value"))