$('#filter-tags').tagsinput({
  tagClass: 'upcase label label-primary',
  itemValue: 'id',
  itemText: 'text'
})

// add initial tags
$('#taxon-filters-form input:checked').each(function(){
  pm.manageFilterTags(this)
})
