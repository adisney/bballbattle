function onManage() {
  var selectedTeams = [];
  var teams;

  function user() {
    return $.cookie('username');
  }
  function alreadyLoggedIn() {
    return user();
  }

  function pickToString(obj) {
    return obj.seed + '. ' + obj.name;
  }
  function substringMatcher(objs) {
    var strs = _.map(objs, function(obj) {
      return pickToString(obj);
    });
    return function findMatches(q, cb) {
      var matches, substrRegex;
      matches = [];
      substrRegex = new RegExp(q, 'i');
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push({ value: str });
        }
      });

      cb(matches);
    };
  };

  function onLoggedIn() {
    var manageForm = $("#templates .manage-form").clone();

    function populateTeams() {
      var panel = manageForm.find('.teams-panel');
      panel.empty();
      panel.append($("#templates .panel-body").clone());
      _.each(selectedTeams, function(team, index) {
        var entry = $("#templates .team-entry").clone();
        entry.find('.delete-btn').click(function() {
          var team = $(this.parentNode).find('.team-name').text();
          $(this).remove();
          deleteTeam(user(), team);
        });
        entry.find('.team-name').text(team);
        panel.find('.team-row' + (index % 2)).append(entry);
      });
    }

    function addTeam(user, team) {
      var seedless_team = team.replace(/\d+\. /, "");
      console.log("Adding team " + team + " for user " + user);
      if (selectedTeams.length < 8 && _.contains(_.keys(teams), seedless_team)) {
        selectedTeams.push(team);
        $(this).val('');
      }
      populateTeams(selectedTeams);
      manageForm.find('.apply-btn').removeClass('disabled');
    }

    function deleteTeam(user, team) {
      console.log("Deleting team " + team + " for user " + user);
      selectedTeams = _.without(selectedTeams, team);
      populateTeams(selectedTeams);
      manageForm.find('.apply-btn').removeClass('disabled');
    }

    manageForm.find('.log-out-btn').click(function() {
      $.removeCookie('username');
      window.location.reload();
    });

    $.ajax('/teams').success(function(data) {
      function display(team) {
        return team.name;
      }
      teams = JSON.parse(data);
      manageForm.find('.typeahead').typeahead(
        { minLength: 1, highlight: true }, 
        { name: 'teams', displayKey: 'value', source: substringMatcher(teams) }
      );
      manageForm.find('.typeahead').keypress(function(e) {
        if(e.keyCode == 13) {
          addTeam(user(), $(this).val());
        }
      });
      manageForm.find('.add-team-btn').click(function(e) {
        addTeam(user(), manageForm.find('.tt-input').val());
      });
    });
    setTimeout(function(){ $('.typeahead').focus(); }, 100);
    manageForm.find('.username').append(user());
    $.ajax("/player?name=" + user()).success(function(picks) {
      selectedTeams = JSON.parse(picks);
      populateTeams();
    });
    manageForm.find('.apply-btn').click(function() {
      $.ajax({url: "/update",
             data: {
               name: user(),
               picks: selectedTeams
             },
             method: "POST"
      });
      window.location.reload();
    });

    return manageForm;
  }

  function onUnregistered() {
    var form = $('#templates .log-in-form').clone();
    form.find('.log-in-btn').click(function() {
      var name = form.find('.username').val().trim().replace(/\s+/g, " ");
      if(name) {
        $.cookie('username', name, {expires: 90, path:'/'});
        window.location.reload();
      } else {
        alert("Must enter a username");
      }
    });
    return form;
  }

  var form;
  if (alreadyLoggedIn()) {
    form = onLoggedIn();
  } else {
    form = onUnregistered();
  }
  $('.main-container').append(form);
}
