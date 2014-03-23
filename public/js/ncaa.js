function on_success(response) {
  _.each(response, function(data, player) {
    row = $(".template").clone().removeClass("template");
    row.find(".player").append(player);
    index = 0;
    _.each(data.picks, function(seed, team) {
      row.find(".team" + (index + 1)).append(seed + ". " + team)
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
