$(function() {
  var editableIds = ['page_content']
  editableIds.forEach(function(id) {
    if ($("#" + id).length) {
      CKEDITOR.replace(id);
    }
  })
});
