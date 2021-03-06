

var countdowns = [];

function countdown(countdown_id) {

  var expiration = $(countdown_id + " .countdown").data("expiration")
  var msToGo = (moment(expiration) - moment());
  var seconds = (msToGo / 1000);
  // -- ugly fix
  seconds = seconds + (2 * 60 * 60);
  // -- ugly fix
  var target_date = new Date().getTime() + (( seconds ) * 1000); // set the countdown date
  var time_limit = ((minutes * 60 ) * 1000);
  var days, hours, minutes, seconds; // variables for time units
  var $countdown = $(".tiles"); // get tag element

  _.each(countdowns, function(i){
    window.clearInterval(i);
  });
  countdowns = [];

  getCountdown();
  countdowns.push(setInterval(function () { getCountdown(); }, 1000));

  function getCountdown(){
    // find the amount of "seconds" between now and target
    var current_date = new Date().getTime();
    var seconds_left = (target_date - current_date) / 1000;

    if ( seconds_left >= 0 ) {
      days = pad( parseInt(seconds_left / 86400) );
      seconds_left = seconds_left % 86400;

      hours = pad( parseInt(seconds_left / 3600) );
      seconds_left = seconds_left % 3600;

      minutes = pad( parseInt(seconds_left / 60) );
      seconds = pad( parseInt( seconds_left % 60 ) );

      // format countdown string + set tag value
      $countdown.html("<span>" + hours + ":</span><span>" + minutes + ":</span><span>" + seconds + "</span>");
    }
  }


  function pad(n) {
    return (n < 10 ? '0' : '') + n;
  }
}
