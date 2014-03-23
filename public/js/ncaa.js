function on_success(response) {
  _.each(response, function(data, player) {
    row = $(".template").clone().removeClass("template");
    row.find(".player").append(player);
    index = 0
    _.each(data.picks, function(teamData, team) {
      teamDiv = row.find(".team" + (index + 1));
      teamDiv.append(teamData.seed + ". " + team);
      if (teamData.knocked_out === true) {
        teamDiv.addClass("knocked-out");
      }
      index += 1;
    });
    row.find(".total").append(data.total);

    $(".content").append(row);
  });
}

$(document).ready(function() {
  $.ajax({
    url: "/picks",
    success: on_success,
    dataType: "json",
    type: "GET"
  });
});
