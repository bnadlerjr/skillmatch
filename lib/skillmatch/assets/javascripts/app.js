$(document).ready(function () {
  function skillList(skills) {
    return $.map(skills["all"], function(value) {
      return value["skill"]["name"];
    }).join(', ');
  }

  function renderResults(data) {
    var items = [];
    $.each(data, function(key, value) {
      var fullName = value["first_name"] + ' ' + value["last_name"];
      items.push('<li id="' + value["id"] + '">' +
        '<img class="profile-pic" src="' + value["picture_url"] + '" />' +
        '<div>' +
        '<h2>' + fullName + '<span> (' + Math.floor(value["similarity"] * 100) + '% match)</span>' + '</h2>' +
        '<a href="' + value["public_profile_url"] + '" style="text-decoration:none;"><span style="font: 80% Arial,sans-serif; color:#0783B6;"><img src="http://www.linkedin.com/img/webpromo/btn_in_20x15.png" width="20" height="15" alt="View ' + fullName + '\'s LinkedIn profile" style="vertical-align:middle" border="0">View ' + fullName + '\'s profile</span></a>' +
        '<p>' + skillList(value["skills"]) + '</p>' +
        '</div>' +
        '</li>');
    });
    $("#results").empty().append(items.join(''));
  }

  $("#search").click(function () {
    var term = $("#term").val();
    $.getJSON('/search?term=' + term, renderResults);
  });
});
