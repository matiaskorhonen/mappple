jQuery ->
  initialize_map(->
    url = ""
    $.history.init (hash) ->
      if hash == "debuts" || hash == "everyone" || hash == "popular"
        url = "http://api.dribbble.com/shots/" + hash + "?callback=?"
        $("#list button").removeClass("blue")
        $("#list button." + hash).addClass("blue")
      else
        url = "http://api.dribbble.com/shots/popular?callback=?"
    get_shots(url)
  )

  $("#list button").click ->
    $("#list button").removeClass("blue")
    $(this).addClass("blue")
    list = $(this).data("list")
    url = "http://api.dribbble.com/shots/" + list + "?callback=?"
    get_shots(url)
    jQuery.history.load(list)
  
  year = (new Date).getFullYear()
  copyright_year = if year > 2011 then "2011 – #{ year }" else "#{year}"
  $("footer span.year").text(copyright_year)


initialize_map = (callback) ->
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
  window.google_map = new google.maps.Map(document.getElementById("map"), map_options)
  window.google_geocoder = new google.maps.Geocoder()
  callback()

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
        title: shot["player"]["location"]
      )

      window.map_overlays.push marker

      google.maps.event.addListener(marker, "click", ->
        window.google_map.setCenter(marker.getPosition())
        infowindow.open(window.google_map, marker)
      )
    )

geocode_location = (location, success) ->
  url = "http://api.geonames.org/search?callback=?"
  geonames_options =
    q: location
    maxRows: 1
    style: "SHORT"
    lang: "en"
    username: "matias"
    type: "json"
    
  google_geocoder_errors = [
    google.maps.GeocoderStatus.OVER_QUERY_LIMIT,
    google.maps.GeocoderStatus.REQUEST_DENIED,
    google.maps.GeocoderStatus.INVALID_REQUEST
  ]

  local_value = store.get(location)

  if local_value?
    success(new google.maps.LatLng(local_value[0], local_value[1]))
  else
    window.setTimeout(->
      window.google_geocoder.geocode(
        address: location
        , (results, status) ->
          if status == google.maps.GeocoderStatus.OK
            latlng = results[0].geometry.location
            store.set(location, [latlng.lat(), latlng.lng()])
            success(latlng)
          else if status in google_geocoder_errors
            $.getJSON(url, geonames_options, (data) ->
              if data["status"]?
                if data["status"]["value"] in [18, 19, 20]
                  $("#error").text("Something went wrong.").slideDown()
              else
                $("#error").text("").slideUp()
                if data["geonames"].length > 0
                  lat = data["geonames"][0]["lat"]
                  lng = data["geonames"][0]["lng"]
                  store.set(location, [lat, lng])
                  success(new google.maps.LatLng(lat, lng))
            )
      )
    , 200
    )
