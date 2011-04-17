$(document).ready ->
  initialize_map();
  
  url = ""
  $.history.init (hash) ->
    if hash == "debuts" || hash == "everyone" || hash == "popular"
      url = "http://api.dribbble.com/shots/" + hash + "?callback=?"
      $("#list button").removeClass("blue")
      $("#list button." + hash).addClass("blue")
    else
      url = "http://api.dribbble.com/shots/popular?callback=?"
  get_shots(url)

  $("#list button").click ->
    $("#list button").removeClass("blue")
    $(this).addClass("blue")
    list = $(this).data("list")
    url = "http://api.dribbble.com/shots/" + list + "?callback=?"
    get_shots(url)
    jQuery.history.load(list)


initialize_map = ->  
  latlng = new google.maps.LatLng(56, 9)

  map_options =
    zoom: 3
    minZoom: 1
    maxZoom: 10
    center: latlng
    mapTypeId: google.maps.MapTypeId.ROADMAP
    panControl: true
    zoomControl: true
    mapTypeControl: false
    scaleControl: true
    streetViewControl: false
    overviewMapControl: false
  
  window.map_overlays = []
  window.google_map = new google.maps.Map(document.getElementById("map"), map_options);

get_shots = (url) ->
  $(".spinner").fadeIn("fast")
  $.getJSON(url, { per_page: 30, page: 1 }, (data) ->
    for marker in window.map_overlays
      marker.setMap(null);
    window.map_overlays.length = 0
    mark_shot shot for shot in data["shots"]
    $(".spinner").fadeOut("fast")
  )

mark_shot = (shot) ->
  if shot["player"]["location"] != null
    geocode_location(shot["player"]["location"], (latlng) ->
      fragment = new EJS({url: "/scripts/templates/shot_info.ejs"}).render(shot)

      infowindow = new google.maps.InfoWindow(
        content: fragment
      )

      marker = new google.maps.Marker(
        map: window.google_map
        position: latlng
        title: shot["title"]
      )

      window.map_overlays.push marker

      google.maps.event.addListener(marker, "click", ->
        window.google_map.setCenter(marker.getPosition())
        infowindow.open(window.google_map, marker)
      )
    )

geocode_location = (location, success) ->
  latlng = null
  url = "http://api.geonames.org/search?callback=?"
  geonames_options =
    q: location
    maxRows: 1
    style: "SHORT"
    lang: "en"
    username: "matias"
    type: "json"
  
  $.getJSON(url, geonames_options, (data) ->
    if data["geonames"].length > 0
      lat = data["geonames"][0]["lat"]
      lng = data["geonames"][0]["lng"]
      success(new google.maps.LatLng(lat, lng))
  )