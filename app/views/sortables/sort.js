// Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

var current_sortable_position = {};
$('.sortable_position').each(function() {
  current_sortable_position[$(this).attr('data-sortable_scope')] =
    ((typeof current_sortable_position[$(this).attr('data-sortable_scope')] === 'undefined') ?
      ($(this).attr('data-sortable_start_at') - 1) : current_sortable_position[$(this).attr('data-sortable_scope')]) + 1;
  $(this).html(current_sortable_position[$(this).attr('data-sortable_scope')]);
});
