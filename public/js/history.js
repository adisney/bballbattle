function onPageReady() {
  function onSuccess(data) {
    var history = JSON.parse(data);
    buildHallOfFame(history);
  }
  
  $.ajax('http://localhost:8080/history?year=' + getParameterByName('year')).success(onSuccess);
}

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(location.search);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function buildHallOfFame(history) {
  $('.year').text(getParameterByName('year'));
  var sorted = _.sortBy(history, 'score').reverse();
  _.each(sorted, function(player, index) {
    console.log(player.name);
    var row = $('#templates .player-row').clone();
    row.find('.place').text(index + 1 + ".");
    row.find('.name').text(player.name);
    row.find('.points').text(player.score);
    _.each(player.picks, function(team, index) {
      var num = (index + 1) % 2 ? "1" : "2";
      row.find('.col' + num).append($('<div>').text(team));
    });
    $('.table').append(row);
  });
}
