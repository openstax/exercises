// Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.
//
//= require markitup/jquery.markitup
//= require ose_markitup_set

$(document).ready(function() {
   enableMarkItUp();
});

// Only plug markItUp! once on each textarea
function enableMarkItUp() {
  $(".markItUp").each(function() {
    if (!($(this).hasClass("markItUpEditor"))) {
      $(this).markItUp(mySettings);
    }
  });
}
