function onManage() {
  var selectedTeams = [];

  function user() {
    return $.cookie('username')
  }
  function alreadyLoggedIn() {
    return user();
  }

  function substringMatcher(strs) {
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
      console.log("Adding team " + team + " for user " + user);
      if (selectedTeams.length < 8) {
        selectedTeams.push(team);
      }
      populateTeams(selectedTeams);
    }
    function deleteTeam(user, team) {
      console.log("Deleting team " + team + " for user " + user);
      selectedTeams = _.without(selectedTeams, team);
      populateTeams(selectedTeams);
    }

    manageForm.find('.log-out-btn').click(function() {
      $.removeCookie('username');
      window.location.reload();
    });
    var teams = ["Illinois", "Michigan", "TCU", "Lousiville", "Iowa State", "BYU", "Ohio State"];
    var typeaheadReference = manageForm.find('.typeahead').typeahead({
      minLength: 1,
      highlight: true,
    },
    {
      name: 'teams',
      displayKey: 'value',
      source: substringMatcher(teams)
    });
    manageForm.find('.typeahead').keypress(function(e) {
      if(e.keyCode == 13) {
        console.log("enter hit");
        var team = $(this).val();
        addTeam(user(), team);
        $(this).val('');
      }
    });
    setTimeout(function(){ $('.typeahead').focus(); }, 0);

    return manageForm;
  }

  function onUnregistered() {
    var form = $('#templates .log-in-form').clone();
    form.find('.log-in-btn').click(function() {
      var name = form.find('.username').val();
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
