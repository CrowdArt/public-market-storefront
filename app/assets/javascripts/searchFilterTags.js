// separated from searchFilters to evaluate it on every page load

$('#filter-tags').tagsinput({
  tagClass: 'upcase label label-primary',
  itemValue: 'id',
  itemText: 'text'
})

// add initial tags
$("#search-filters-form input:checked, #search-filters-form input[name='keywords']").each(function(){
  pm.manageFilterTags(this)
})

pm.setSelectionsCount()
