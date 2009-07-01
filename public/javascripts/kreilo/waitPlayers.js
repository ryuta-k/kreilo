function waitPlayers(url1, url2){
    //show progress bar while waiting other player.
    //if it takes for 1 min. skip to next Page

    var pB = new ProgressBar($('dialog-content'), {classProgressBar: 'progressBar2', style: ProgressBar.INDETERMINATE|ProgressBar.TRANSPARENCY,noIndeterminateIndicators: 15, color:{r:50,g:50,b:255}});
    var timer = 10; 
    var pE = new PeriodicalExecuter(loop, 1);
    function loop(){
        timer--;
        var a = new Ajax.Request(
                                 url1,
                                 {
                                     "method": "get",
                                     "parameters": "a=b&c=d&e=f",
                                     onSuccess: function(request){

                                     },
                                     onComplete: function(request) {
                                         var json = request.responseText;
                                         $('container').innerHTML = json;
                                         if((/true/i).test(json)){
                                             pE.stop();
                                             jump();
                                         }
                                     },
                                     onFailure: function(request) {
                                         alert('Failure' + timer );
                                     },
                                     onException: function (request) {
                                         alert('Exception' + timer);
                                     }
                                 }
                                 );
        if(timer < 1){
            pE.stop();
            jump()
                }
    }
    function jump(){
        location.href = url2;
    }
}
