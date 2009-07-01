function timer(timeID, barID){
    var div = $(timeID);
    var sec = div.innerHTML;
    var date = new Date();
    var pBar = new ProgressBar($(barID), {classProgressBar: 'progressBar', style: ProgressBar.DETERMINATE, maximum: 115, selection:sec});
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
