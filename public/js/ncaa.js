function on_success(playerPicks) {
  _.each(playerPicks, function(picks, player) {
    row = $(".template").clone().removeClass("template");
    row.find(".player").append(player);
    index = 0
    _.each(picks, function(seed, team, d) {
      row.find(".team" + (index + 1)).append(seed + ". " + team)
      index += 1;
    });

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
