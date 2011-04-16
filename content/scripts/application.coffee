overlays = []
geocoder = new google.maps.Geocoder
map = null

$(document).ready ->
  initialize_map();
  
  url = ""
  $.history.init (hash) ->
    if hash == "debuts" || hash == "everyone" || hash == "popular"
      url = "http://api.dribbble.com/shots/" + hash + "?callback=?"
    else
      url = "http://api.dribbble.com/shots/popular?callback=?"
  get_shots(url);

  $("#list button").click ->
    list = $(this).data("list");
    url = "http://api.dribbble.com/shots/" + list + "?callback=?"
    get_shots(url);
    jQuery.history.load(list);


initialize_map = ->  
  geocoder = new google.maps.Geocoder

  latlng = new google.maps.LatLng(60.162782, 24.919489)

  map_options =
    zoom: 3
    minZoom: 1
    center: latlng
    mapTypeId: google.maps.MapTypeId.ROADMAP
    panControl: true
    zoomControl: true
    mapTypeControl: false
    scaleControl: true
    streetViewControl: false
    overviewMapControl: false

  map = new google.maps.Map(document.getElementById("map"), map_options);

get_shots = (url) ->
  for marker in overlays
    marker.setMap(null);
  overlays.length = 0
  
  $.getJSON(url, { per_page: 30, page: 1 }, (data) ->
    for shot in data["shots"]
      geocode_and_mark_shot(shot, map) if shot["player"]["location"] != null
  )


geocode_and_mark_shot = (shot, map) ->
  infowindow = new google.maps.InfoWindow(
    content: new EJS({url: "/scripts/templates/shot_info.ejs"}).render(shot)
  )
  
  geocoder.geocode(
    address: shot["player"]["location"],
    (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        marker = new google.maps.Marker(
          map: map
          position: results[0].geometry.location
          title: shot["title"]
        )
        overlays.push marker
        google.maps.event.addListener(marker, 'click', ->
          infowindow.open(map,marker)
        )
      else
        console.log status
  )