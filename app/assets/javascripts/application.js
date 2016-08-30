//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets

//= require underscore
//= require gmaps/google
//= require_tree .

(function() {
  /* __markers will hold a reference to all markers currently shown
     on the map, as GMaps4Rails won't do it for you.
     This won't pollute the global window object because we're nested
     in a "self-executed" anonymous function */
  var __markers;

  function updateMarkers(map, markersData, oldMarkersData)
  {

    intersection = _.intersection(oldMarkersData, markersData);
    toKeep = _.difference(markersData, intersection);
    toRemove = _.difference(oldMarkersData, intersection);

    toRemove = map.addMarkers(toRemove);
    // Remove current markers
    map.removeMarkers(toRemove);

    // Add each marker to the map according to received data
    __markers = _.map(markersData, function(markerJSON) {
      marker = map.addMarker(markerJSON);
      map.getMap().setZoom(4); // Not sure this should be in this iterator!

      _.extend(marker, markerJSON);

      marker.infowindow = new google.maps.InfoWindow({
        content: marker.infowindow
      });

      google.maps.event.addListener(marker.getServiceObject(), 'click', function(){
        var box_id = marker.serviceObject.title
        $.ajax({
          method: "POST",
          url: "http://localhost:3000/boxes/" + box_id + "/preview",
          data: { "lat": lat, "lng": lng },
          success: function(data) {
            var infowindow = new google.maps.InfoWindow({content: data});
            infowindow.open( handler.getMap(), marker.getServiceObject());
          }
        });
      });
      return marker;
    });
    console.log(map)
    map.bounds.extendWith(__markers);
    map.fitMapToBounds();
  };

  // "Publish" our method on window. You should probably have your own namespace
  window.updateMarkers = updateMarkers;
})();
