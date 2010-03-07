var animateInterval = 50;
var animation = "swing";
var displayOffset = 30;

var Scroller = {
  elementWidth : function(){
    return 960;
  },
  windowWidth : function(){
    return $(window).width();
  },
  elementMargin : function(){
    return (Scroller.windowWidth() - Scroller.elementWidth())/2;
  },
  resized : function(){
    $('#icontainer').height($(window).height() - 20);
    $('#iscroller').height($(window).height() - 30);
    $('#iscroller > li').css('margin-left', Scroller.elementMargin() - displayOffset);
    $('#iscroller > li.ifirst').css('margin-left', Scroller.elementMargin());
    $('#iscroller > li').css('width', Scroller.elementWidth());
  }
}


$(document).ready(function() {
  $(window).resize(function() {
    Scroller.resized();
  });
  Scroller.resized();

  $('#iscroller > li:not(.icenter)').live('click mouseover mouseout', function(event) {
    var me              = $(this);
    var center          = $('.icenter');
    var parent          = me.parent();
    var motionDirection = me.hasClass('ileft') ? 1 : -1;
    
    if(event.target == this) return;

    if (event.type == 'mouseover') {
      me.css('position', 'relative');
      me.animate({ left: motionDirection*20 }, animateInterval, animation);
      center.animate({ opacity: 0.50 }, animateInterval);
    } else if (event.type == 'mouseout') {
      me.css('position', 'static');
      me.animate({ left: 0 }, animateInterval, animation);
      center.animate({ opacity: 1 }, animateInterval);
    } else {
      me.css('position', 'static');
      me.css('left', 0);
      parent.css('position', 'relative');
      center.animate({ opacity: 1 }, animateInterval);

      var motionDistance =  Scroller.elementWidth() + Scroller.elementMargin() - displayOffset;
      parent.animate({ left:  parseInt(parent.css('left')) + motionDirection*motionDistance }, animateInterval, animation);

      me.prev().addUniqueClass('ileft');
      me.addUniqueClass('icenter');
      me.next().addUniqueClass('iright');
    }
  });
});

$.fn.addUniqueClass = function(classname){
  $('.' + classname).removeClass(classname);
  $(this).addClass(classname);
}