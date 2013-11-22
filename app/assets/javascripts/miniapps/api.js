var sync = Backbone.sync;
Backbone.sync = function(method, model, options) {
  options.beforeSend = function (xhr) {
    xhr.setRequestHeader('Accept', 'application/vnd.exercises.openstax.v1');
  };

  // Update other options here.

  sync(method, model, options);
};

var apiGet = function(url) {
  jQuery.ajax({
    url:url,
    beforeSend: function(xhr) { 
      xhr.setRequestHeader('Accept','application/vnd.exercises.openstax.v1');
    },
    success: function(data,textStatus,xhr) { 
      console.log(xhr.responseText); 
      console.log(data);
    }
  });
};
