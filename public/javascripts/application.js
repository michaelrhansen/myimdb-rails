var Rails = {
  windowSizes : {
    twitter : {
      width  : 800,
      height : 450
    },
    gridbag : {
      width  : 800,
      height : 450
    }
  },
  highlightDelay : 3000,
  flashShowDelay : 5000
}

$(document).ready(function(){
  $('#flashClose').click(function(){
    $(this).parents('#flash').hide();
  });
  $('#twitterPopup').click(function(){
    PopUpWindow($(this).attr('href'), 'twitter');
    return false;
  });
  $('#gridbagPopup').click(function(){
    PopUpWindow($(this).attr('href'), 'gridbag');
    return false;
  });
  $('.autoload').click();
  Flash.show();
  ShowFormErrors();
  // MonitorResize();
  InitializeRemoteResources();
  InitializeRemoteLinks();
  InitializeGallery();
});
MonitorResize = function(){
  Resized();
  $(window).resize(Resized);
}
Resized = function(){
  $('#body').width($(window).width() - 260);
}
InitializeRemoteResources = function(){
  $('.has-remote-resource ul li.clickable').live('click', function(){
    var me  = $(this).parents('li');

    if(me.hasClass('active-movie')) {
      me.removeClass('active-movie');
    }
    else {
      $.historyLoad(me.attr('id'));
    }
  });
}
InitializeRemoteLinks = function(){
  $('a[data-ajax]').live('click', function(event){
    event.preventDefault(); 

    var me            = $(this);
    var request_url   = me.attr('href');
    var request_type  = me.attr('data-type') || "POST";

    var options       = {
      url       : request_url,
      dataType  : "script",
      type      : request_type,
    };

    var spinner_id        = me.attr('data-spinner');
    
    // code to be executed on success
    var complete_function = me.attr('data-complete');
    var success_options   = { me : me };
    if(spinner_id) {
      $('#' + spinner_id).show();
      $.extend(success_options, { spinner_id : spinner_id });
    }
    if(complete_function){
      $.extend(success_options,{ complete_function : complete_function });
    }
    $.extend(options, { success : function(){ successData(success_options) } });

    $.ajax(options);
  });
}
successData = function(options){
  if(options.spinner_id)
    $('#' + options.spinner_id).hide();
  if(options.complete_function)
    eval(options.complete_function + "(options.me)");
}

toggleActiveStatusClass = function(me){
  me.toggleClass('active');
}
// PageLoad function
// This function is called when:
// 1. after calling $.historyInit();
// 2. after calling $.historyLoad();
// 3. after pushing "Go Back" button of a browser
function pageload(hash) {
  // alert("pageload: " + hash);
  if(hash) {
    if($.browser.msie) {
      hash = encodeURIComponent(hash);
    }
    var me  = $("#" + hash);
    me.addUniqueClass('active-movie');
    Overlay.Load(me.attr('href'));
  }
  else {
    Overlay.Hide();
  }
}

$(document).ready(function(){
  // Initialize history plugin.
  // The callback is called at once by present location.hash. 
  $.historyInit(pageload, window.location.url);

  // set onlick event for buttons
  $("a[rel='history']").click(function(){
    var hash = this.href;
    hash = hash.replace(/^.*#/, '');
    // moves to a new page. 
    // pageload is called at once. 
    // hash don't contain "#", "?"
    $.historyLoad(hash);
    return false;
  });
});


ShowFormErrors = function(){
  $("form:has('#errorExplanation')").find("input[type='text'][title], input[type='password'][title], textarea").tooltip({ 
    tip      : '#globalTooltip', 
    offset   : [45, 10],
    position : 'top right',
    opacity  : 0.7,
    effect   : 'slide',
    events   : {
      input  : 'mouseover focus, mouseout blur'
    }
  }).dynamic({ 
    // customized configuration on bottom edge
    bottom: { 
      // slide downwards
      direction : 'down',
      // bounce back when closed
      bounce    : true 
    } 
  });
}

$.fn.checkFormFields = function() {
  var me = jQuery(this);
  me.find('input[blur_text], textarea[blur_text]').each(function(){
    if(jQuery(this).attr('blur_text') == jQuery(this).val())
      jQuery(this).val('');
  });
  return me;
};
$.fn.checkFormFieldsAlt = function() {
  jQuery(this).checkFormFields();
  var me = jQuery(this);
  setTimeout(function(){
    me.find("input, select, textarea").attr("disabled","disabled")
  }, 10);
  return true;
};
$.fn.resetForm = function() {
  var me = jQuery(this);
  me.find("input, select, textarea").attr("disabled",false);
  me.reset();
}
$.fn.addUniqueClass = function(className){
  jQuery('.' + className).removeClass(className);
  jQuery(this).addClass(className);
};

PopUpWindow = function(path, account){
  var width   = Rails.windowSizes[account].width;
  var height  = Rails.windowSizes[account].height;
  var left    = parseInt((screen.availWidth/2) - (width/2));
  var top     = parseInt((screen.availHeight/2) - (height/2));
  var windowFeatures = "width=" + width + ",height=" + height + ",status,resizable,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top;
  myWindow = window.open(path, "authentication_popup", windowFeatures);
};

var Overlay = {
  Show : function(){
    $('#overlay').show('fast', function(){Overlay.Init()});
    $('#background').hide();
  },
  Hide : function(){
    Overlay.Exit();
    $('#overlay').hide();
    $('#background').show();
  },
  Next: function(){
    $('.active-movie').next().find('li.name').click();
  },
  Previous: function(){
    $('.active-movie').prev().find('li.name').click()
  },
  Load: function(url){
    $('#lightbox-content').load(url);
    Overlay.Show();
  },
  Init: function(){
    setTimeout(function(){ $('#tabs').tabs({
      load: AjaxTabLoaded,
      show: LocalTabLoaded,
      cache: true
    }); },500);
    FetchRemoteUserDetails();
  },
  Exit: function(){
    window.location.href = window.location.href.split("#")[0] + "#"
  }
}
AjaxTabLoaded = function(){
  FetchRemoteUserDetails();
}

LocalTabLoaded = function(){
  $("#sortable-images").sortable({
    items       : 'li.ui-state-default',
    placeholder : 'ui-state-highlight',
    stop        : function(){
      var me = $("#sortable-images");
      var movie_id = me.attr('data-movie-id');
      var medias = $.map(me.find('li.ui-state-default'), function(element){
        return $(element).attr('id');
      });
      $.ajax({
        url   : '/movies/'+ movie_id +'/medias/sort',
        type  : 'PUT',
        data  : { "medias[]" : medias }
      });
    }});
  $("#sortable-images img").disableSelection();
}
FetchRemoteUserDetails = function(){
  var users = $.map($('.remote-user').removeClass('remote-user'), function(user){
    return $(user).attr('id')
  });
  if(users.length != 0){
    $.ajax({
      url       : '/users/follow_status',
      dataType  : 'script',
      data      : { 'users[]' : users }
    });
  }
}
InitializeGallery = function(){
  $("div.scrollable").scrollable({ size: 1, clickable: false });

  var images = $(".scrollable a");
  if(images.length == 0) return;
  $(".scrollable a").overlay({ 
    // each trigger uses the same overlay with the id "gallery" 
    target: '#gallery', 
    // optional exposing effect 
    expose: '#000' 
    // let the gallery plugin do its magic! 
  }).gallery({ 
    // the plugin accepts its own set of configuration options 
    speed: 800 
  });
}

Flash = {
  notice : function(msg){
    this.message("<div class='notice'>" + msg + "</div>");
  },
  error : function(msg){
    this.message("<div class='error'>" + msg + "</div>");
  },
  message : function(msg){
    $('#flash').html(msg);
    this.show();
  },
  show : function(){
    if($('#flash > div').text() != "")
      $('#flash').slideDown(200).fadeTo(Rails.flashShowDelay, 1).slideUp(200, function(){ jQuery(this).html('') });
  }
}

Search = {
  fuzzy : function(q){
    $('#fuzzy-search-results').load('/movies/fuzzy?q=' + encodeURI(q));
  }
}