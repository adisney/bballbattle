function markIfEliminated(elem, teamData) {
}

function populateTeamDetails(row, team, index, teamData) {
  teamDiv = row.find(".team" + (index + 1));
  teamDiv.append(teamData.seed + ". " + team);
  markIfEliminated(teamDiv, teamData);
  teamDiv.find(".team-logo").attr("src", teamData.logo_url);
  if (teamData.knocked_out === true) {
    teamDiv.addClass("knocked-out-details");
  }
  return row.find(".details");
}

function populateTeamLogos(row, teamData) {
  imgTag = row.find(".logos > .template").clone();
  imgTag.removeClass("template").removeClass("hidden");
  imgTag.attr("src", teamData.logo_url);
  if (teamData.knocked_out === true) {
    imgTag.addClass("knocked-out-logos");
  }
  row.find(".logos > .row-fluid").append(imgTag);
  return row.find(".logos");
}

function configOnClick(details, logos) {
  details.click(function() {
    details.addClass('hidden');
    logos.removeClass('hidden');
  });
  logos.click(function() {
    details.removeClass('hidden');
    logos.addClass('hidden');
  });
}

function on_success(response) {
  $(".update-time").text(response.update_time);

  rows = [];
  _.each(response.player_picks, function(data, player) {
    row = $(".template").clone().removeClass("template");
    row.find(".player").append(player);

    index = 0
    _.each(data.picks, function(teamData, team) {
      details = populateTeamDetails(row, team, index, teamData);
      logos = populateTeamLogos(row, teamData);

      configOnClick(details, logos);

      index += 1;
    });

    row.find(".total").append(data.total);
    rows.push(row);
  });

  rows = _.sortBy(rows, function(row) {
    return row.find(".total").text();
  }).reverse();

  place = 1;
  _.each(rows, function(row) {
    player = row.find(".player");
    player.prepend(place + ". ")
    place += 1;
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
