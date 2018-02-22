document.addEventListener("turbolinks:load", function() {
  $("input[name='to_do_list_item[done]']").on("click", function() {
    $(this).parents("form:first").find("input[type='submit']").click()
  })
})
