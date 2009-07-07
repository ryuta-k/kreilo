function waitPlayers(url1, id){
    //show progress bar while waiting other player.
    //if it takes for 1 min. skip to next Page
    var pB = new ProgressBar($('dialog-content'), {classProgressBar: 'progressBar2', style: ProgressBar.INDETERMINATE|ProgressBar.TRANSPARENCY,noIndeterminateIndicators: 15, color:{r:50,g:50,b:255}});
    var timer = 10; 
    var pE = new PeriodicalExecuter(loop, 1);

    function loop(){
    
        var a = new Ajax.Request(
                                 url1,
                                 {
                                     "method": "get",
                                     "parameters": "?id="+id,
                                     onSuccess: function(request){

                                     },
                                     onComplete: function(request) {
                                         var json = request.responseText;
                                         $('container').innerHTML = json;
                                         if((/true/i).test(json)){
                                             pE.stop();
                                         }
                                     },
                                     onFailure: function(request) {
                                   //      alert('Failure' + timer );
                                     },
                                     onException: function (request) {
                                         alert('Exception' + timer);
                                     }
                                 }
                                 );

    }
}


