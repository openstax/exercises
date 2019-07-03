// Copyright 2011-2019 Rice University. Licensed under the Affero General Public
// License version 3 or later.  See the COPYRIGHT file for details.
//
//= require markitup/jquery.markitup
//= require ose_markitup_set

var attachmentsDialogTarget;

// Only plug markItUp! once on each textarea
function enableMarkItUp() {
  $('.markItUp').each(function() {
    if (!($(this).hasClass('markItUpEditor'))) {
      $(this).markItUp(mySettings);
    }
  });
}

function bindAttachmentsDialogImages() {
  $('#attachments_dialog .image_thumb').off('dblclick');
  $('#attachments_dialog .image_thumb').on('dblclick', function(evt, data, status, xhr) {
     var image_tag = '{img:' + $(this).attr('data-local_name') + '}';
     $(attachmentsDialogTarget).trigger('insertion', [{replaceWith: image_tag}]);
     $('#attachments_dialog').dialog('close');
  });
}

$(document).on('turbolinks:load', function() {
   enableMarkItUp();
   bindAttachmentsDialogImages();
});

function openAttachmentsDialog(target)  {
  attachmentsDialogTarget = target.textarea;

  $('#attachments_dialog').dialog({
    	resizable: true,
    	height:280,
    	width:600,
    	modal: true
    });
}
