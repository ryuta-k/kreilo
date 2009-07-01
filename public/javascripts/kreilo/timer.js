
function timer()
{
  var countdownDiv = document.getElementById('timer');

  if ( countdownDiv === null)
     return;
  else
  {
    var timerValue = parseInt(countdownDiv.innerHTML); // assuming that your running_time is an int (seconds)
    var dateObj = new Date();

    dateObj.setTime( timerValue*1000 );
    countdownDiv.innerHTML = dateObj.getMinutes() + ":" + dateObj.getSeconds();


    displayTimer = function() {
      dateObj.setTime( ( (dateObj.getTime()/1000) - 1 )*1000 );
      if (dateObj.getMinutes() > 0)
        countdownDiv.innerHTML = dateObj.getMinutes() + ":" + dateObj.getSeconds();
      else
        countdownDiv.innerHTML = dateObj.getSeconds();

      //TODO: when 0 ping the server
    }

   var timer = setInterval("displayTimer()", 1000);
  }
}


function kreilo_test()
{
  alert("aaaaaaaaabbbaaaieroweroa");
}



