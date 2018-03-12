function markIfEliminated(elem, teamData) {
}

function populateTeamDetails(row, team, index, teamData) {
  teamDiv = row.find(".team" + (index + 1));
  teamDiv.append(teamData.seed + ". " + team);
  markIfEliminated(teamDiv, teamData);
  teamDiv.find(".team-logo-summary").attr("src", "img/" + teamData.logo);
  if (teamData.knockedOut === true) {
    teamDiv.addClass("knocked-out-details");
  }
  return row.find(".details");
}

function populateTeamLogos(row, teamData) {
  imgTag = $("#templates .team-logo").clone();
  imgTag.attr("src", "img/" + teamData.logo);
  if (teamData.knockedOut === true) {
    imgTag.addClass("knocked-out-logos");
  }
  row.find(".logos .logo-display").append(imgTag);
  return row.find(".logos");
}

function embiggen(details, logos, id) {
  return function() {
    $("." + id + ".glyphicon-plus").addClass("hidden");
    $("." + id + ".glyphicon-minus").removeClass("hidden");
    details.removeClass('hidden');
    logos.addClass('hidden');
    //$("." + id).off("click").click(ensmallen(details, logos, id));
  }
}

function ensmallen(details, logos, id) {
  return function() {
    $("." + id + ".glyphicon-plus").removeClass("hidden");
    $("." + id + ".glyphicon-minus").addClass("hidden");
    details.addClass('hidden');
    logos.removeClass('hidden');
    //$("#" + id).off("click").click(embiggen(details, logos, id));
  }
}

function configOnClick(details, logos, id) {
  details.click(ensmallen(details, logos, id));
  logos.click(embiggen(details, logos, id));
  $("." + id + ".glyphicon-plus").click(embiggen(details, logos, id));
  $("." + id + ".glyphicon-minus").click(ensmallen(details, logos, id));
}

function on_success(response) {
  rows = [];
  _.each(response, function(data) {
    player = data.name
    expanderId = player.trim().replace(' ', '-') + "-expander";

    row = $("#templates .summary").clone();
    row.find(".player").append(player);
    row.find(".expander").addClass(expanderId);
    row.find(".expander.glyphicon-plus").click(embiggen(row.find(".details"), row.find(".logos"), expanderId));
    row.find(".expander.glyphicon-minus").click(ensmallen(row.find(".details"), row.find(".logos"), expanderId));

    index = 0
    if (new Date().getTime() > new Date("2018-03-15 12:00:00 EDT").getTime()) {
      $('.revealed').addClass("hidden");
      _.each(data.picks, function(teamData, team) {
        details = populateTeamDetails(row, team, index, teamData);
        logos = populateTeamLogos(row, teamData);

        configOnClick(details, logos, expanderId);

        index += 1;
      });
    }

    row.find(".total").append(data.score);
    rows.push(row);
  });

  rows = _.sortBy(rows, function(row) {
    return parseInt(row.find(".total").text());
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
    type: "GET",
    cache: "false"
  });
});
