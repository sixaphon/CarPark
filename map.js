var map;

function getParkingSpotsImage(spots){
    if(spots > 0){
        return 'parking-green.png';
    }
    else{
        return 'parking-red.png';
    }
}

var markers;
var infoWindowContent = new Array();

function getMarkers(IndexMarkers){
    markers = IndexMarkers;
    for (var i = 0; i < IndexMarkers.length; i++) {
        IndexMarkers[i][5] = getParkingSpotsImage(IndexMarkers[i][3]);
    }
}

if (navigator.geolocation) {
    
        navigator.geolocation.getCurrentPosition(function (p) {
    
            var currentLatLng = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);

            var currentLocation = ['Your Location', p.coords.latitude, p.coords.longitude, null, null, "loc.png"];
            markers.push(currentLocation);
    
            var mapOptions = {
    
                center: currentLatLng,
    
                zoom: 20,

                disableDefaultUI: true,
    
                mapTypeId: google.maps.MapTypeId.ROADMAP
    
            };

            map = new google.maps.Map(document.getElementById("dvMap"), mapOptions);

            

            // Display multiple markers on a map
            var infoWindow = new google.maps.InfoWindow(), marker, i;
            
            // Loop through our array of markers & place each one on the map  
            for( i = 0; i < markers.length; i++ ) {
                var position = new google.maps.LatLng(markers[i][1], markers[i][2]);
                // bounds.extend(position);
                marker = new google.maps.Marker({
                    position: position,
                    map: map,
                    title: markers[i][0],
                    icon: markers[i][5]
                });

                // var infoWindowContent = [
                //     ['<div class="info_content">' +
                //     '<h3>London Eye</h3>' +
                //     '<p>The London Eye is a giant Ferris wheel situated on the banks of the River Thames. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft).</p>' +        '</div>'],
                //     ['<div class="info_content">' +
                //     '<h3>Palace of Westminster</h3>' +
                //     '<p>The Palace of Westminster is the meeting place of the House of Commons and the House of Lords, the two houses of the Parliament of the United Kingdom. Commonly known as the Houses of Parliament after its tenants.</p>' +
                //     '</div>']
                // ];
                
                // Allow each marker to have an info window    
                google.maps.event.addListener(marker, 'click', (function(marker, i) {
                    return function() {
                        infoWindow.setContent('available: ' + markers[i][3] + ' of ' + markers[i][4]);
                        infoWindow.open(map, marker);
                    }
                })(marker, i));

                //Automatically center the map fitting all markers on the screen
                // map.fitBounds(bounds);
            }
    
            // var marker = new google.maps.Marker({
    
            //     position: LatLng,
    
            //     map: map,
    
            // });
    
            google.maps.event.addListener(marker, "click", function (e) {
    
                var infoWindow = new google.maps.InfoWindow();
    
                infoWindow.setContent(marker.title);
    
                infoWindow.open(map, marker);
    
            });

            // var marker = new google.maps.Marker({
            //   position: {lat: 43.306978, lng: 17.821615},
            //   map: map,
            //   title: 'Parking',
            //   icon: parkingPhoto
            // });
    
        });
    
    } else {
        alert('Geo Location feature is not supported in this browser.');
    }
function zoomIn (number){
    map.setZoom( map.getZoom() + number);
}

function zoomOut (number){
    map.setZoom( map.getZoom() - number);
}