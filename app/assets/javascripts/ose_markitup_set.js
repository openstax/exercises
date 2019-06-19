// Copyright 2011-2019 Rice University. Licensed under the Affero General Public 
// License version 3 or later.  See the COPYRIGHT file for details.

mySettings = {
  onTab:    		{keepDefault:false, replaceWith:'    '},
  markupSet:  [
	  {name:'Bold', key:'B', openWith:'\!\!', closeWith:'\!\!' },
	  {name:'Italic', key:'I', openWith:'\'\'', closeWith:'\'\''  },
	  {name:'Underline', key:'U', openWith:'\_\_', closeWith:'\_\_'},
	  {name:'Picture', key:'P', replaceWith:function (markItUp) {
        openAttachmentsDialog(markItUp);
        return false;
      }
    },
	  {name:'Bullet List', key:'Bl', openWith:'\n\*'},
	  {name:'Numeric List', key:'N_L', openWith:'\n\#'},
	  {name:'Math', key:'M', openWith:'\$', closeWith:'\$'}
  ]
}
