function ease(score, scoreBar, max){
    $(scoreBar).innerHTML = "";
    var div = $(score);
    var point = div.innerHTML;
    var pBar = new ProgressBar($(scoreBar), {classProgressBar: 'progressBar', style: ProgressBar.DETERMINATE, widthIndicators:3,noIndeterminteIndicators:0,selection:1, color:{r:50, g:200, b:200}});
    setTimeout(function(){
            var transObj = new Effect.Transform([{".indicator": 'width:' + (300*(point/max)) +'px'}],{duration:3});
        transObj.play();
            }, 50);
    
    new Effect.Fade("score", {from:0.0, to:0.8, delay:2, duration:1});
}
