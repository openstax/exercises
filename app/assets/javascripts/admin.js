$(document).on('turbolinks:load', function() {
  var getMethod = function() {
    $("#publications-form").attr("method", "get");
    $("#publications-form input[name='_method']").attr("disabled", true);
    $("#publications-form input[name='authenticity_token']").attr("disabled", true);
  }

  $("#query").change(function() {
    getMethod();
    $("#publications-form").submit();
  });

  $("#search").click(getMethod);

  $("#collaborator-action").change(function() {
    $("#commit").val(this.value);
  });

  $("#collaborators-query").on("input", function() {
    req = `/admin/publications/collaborators?collaborators_query=${
      $("#collaborators-query").val()
    }`

    fetch(req, { headers: { "X-Requested-With": "XMLHttpRequest" } }).then(response => {
      if (response.status == 200) {
        return response.text();
      } else {
        return Promise.reject(
          new Error(`Invalid response status code ${response.status} for request ${req}`)
        );
      }
    }).then(text => eval(text));
  });

  $("#commit").click(function() {
    $("#publications-form").attr("method", "post");
    $("#publications-form input[name='_method']").attr("disabled", false);
    $("#publications-form input[name='authenticity_token']").attr("disabled", false);
  });
});
