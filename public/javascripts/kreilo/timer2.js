function timer(timeID, barID){
    var div = $(timeID);
    $(barID).innerHTML = "";
    var sec = div.innerHTML;
    var date = new Date();
    var pBar = new ProgressBar($(barID), {classProgressBar: 'progressBar', style: ProgressBar.DETERMINATE, widthIndicators:1,noIndeterminteIndicators:0,selection:100, color:{r:255, g:100, b:0},colorEnd:{r:100, g:255, b:100}});
    //    var pBar = new ProgressBar($(barID), {classProgressBar: 'progressBar', style: ProgressBar.DETERMINATE, widthIndicators:1,noIndeterminteIndicators:0,selection:100,color:{r:100, g:255, b:100}});
    var pE = new PeriodicalExecuter(loop, 1);
    function loop(){
        sec--;
        date.setTime(sec*1000);
        var ss = date.getSeconds();
        var mm = date.getMinutes();
        div.innerHTML = mm + ":" +( (ss<10)? "0"+ss :ss);

        pBar.setSelection(sec);
        if(sec < 1){
            pE.stop();
            alert("stop();");
        }
    }
    
}