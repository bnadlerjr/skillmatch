$(document).ready(function () {
  function skillList(skills) {
    return $.map(skills["all"], function(value) {
      return value["skill"]["name"];
    }).join(', ');
  }

  function renderResults(data) {
      var items = [];

      $.each(data, function(key, value) {
          value['full_name'] = value['first_name'] + ' ' + value['last_name'];
          value['formatted_similarity'] = Math.floor(value['similarity'] * 100);
          value['skill_list'] = skillList(value["skills"])
          items.push(tmpl("cnn", { cnn: value }));
      });

      $("#results").empty().append(items.join(''));
  }

  $("#search").click(function () {
    var term = $("#term").val();
    $.getJSON('/search?term=' + term, renderResults);
  });
});
