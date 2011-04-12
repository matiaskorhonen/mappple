var geocoder, map, overlays;

overlays = [];

jQuery(function() {
  var url, shots;
  
  $("#list button").bind("click", function() {
    list = $(this).data("list");
    url = "http://api.dribbble.com/shots/" + list + "?callback=?"
    get_shots(url);
    jQuery.history.load(list);
  });
  
  $.history.init(function(hash){
    if(hash == "debuts" || hash == "everyone" || hash == "popular") {
      url = "http://api.dribbble.com/shots/" + hash + "?callback=?"
    } else {
      url = "http://api.dribbble.com/shots/popular?callback=?"
    }
  },
  { unescape: ",/" });
  
  initialize_map();
  get_shots(url);
});

function initialize_map() {
  var map_options, latlng;
  
  geocoder = new google.maps.Geocoder();
  
  latlng = new google.maps.LatLng(60.162782, 24.919489);
  map_options = {
    zoom: 3,
    minZoom: 1,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    panControl: true,
    zoomControl: true,
    mapTypeControl: false,
    scaleControl: true,
    streetViewControl: false,
    overviewMapControl: false
  };
  
  map = new google.maps.Map(document.getElementById("map"), map_options);
};

function geocode_and_mark_shot(shot, map) {
  var contentString = new EJS({url: "/javascripts/templates/shot_info.ejs"}).render(shot);
  
  var infowindow = new google.maps.InfoWindow({
      content: contentString
  });
  
  geocoder.geocode( { 'address': shot["player"]["location"]}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map, 
          position: results[0].geometry.location,
          title: shot["title"]
      });
      
      overlays.push(marker);
      
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map,marker);
      });
    } else {
      console.log(status);
    }
  });
};

function get_shots(url) {
  _.each(overlays, function(marker) {
    marker.setMap(null);
  });
  
  overlays.length = 0;
  
  $.getJSON(url, { per_page: 30, page: 1 }, function(shots) {    
    _.each(shots["shots"], function(shot) {
      if ( shot["player"]["location"] != null ) {
        geocode_and_mark_shot(shot, map);
      }
    });
  });
}