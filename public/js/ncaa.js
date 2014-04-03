function on_success(response) {
  $(".update-time").text(response.update_time);

  rows = []
  _.each(response.player_picks, function(data, player) {
    row = $(".template").clone().removeClass("template");
    row.find(".player").append(player);
    index = 0
    _.each(data.picks, function(teamData, team) {
      teamDiv = row.find(".team" + (index + 1));
      teamDiv.append(teamData.seed + ". " + team);
      if (teamData.knocked_out === true) {
        teamDiv.addClass("knocked-out");
      }
      teamDiv.find(".team-logo").attr("src", teamData.logo_url)
      index += 1;
    });
    row.find(".total").append(data.total);
    rows.push(row);
  });

  rows = _.sortBy(rows, function(row) {
    return row.find(".total").text();
  }).reverse();

  _.each(rows, function(row) {
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
