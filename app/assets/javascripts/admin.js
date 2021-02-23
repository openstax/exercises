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
    const xhr = new XMLHttpRequest();

    xhr.open(
      "GET",
      "/admin/publications/collaborators?collaborators_query=" + $("#collaborators-query").val(),
      true
    );

    // required, otherwise Rails fails with a CORS error even if the request is from the same origin
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

    xhr.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        eval(xhr.responseText);
      }
    };

    xhr.send();
  });

  $("#commit").click(function() {
    $("#publications-form").attr("method", "post");
    $("#publications-form input[name='_method']").attr("disabled", false);
    $("#publications-form input[name='authenticity_token']").attr("disabled", false);
  });
});
