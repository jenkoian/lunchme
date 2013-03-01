'use strict';

lunchMeApp.controller('VenuesController', ['$scope', '$resource', function($scope, $resource) {

   var Venue = $resource("/venues/:id", {id: '@id'}, {
      update: {method:'PUT'}
   });

   $scope.venues = Venue.query();

   $scope.uprate = function(venue) {
      venue.rating = venue.rating != undefined ? parseInt(venue.rating) + 1 : 0;
      var newVenue = new Venue(venue);
      venue = newVenue.$update();
   }
   $scope.downrate = function(venue) {
      venue.rating = venue.rating != undefined ? parseInt(venue.rating) - 1 : 0;
      var newVenue = new Venue(venue);
      venue = newVenue.$update();
   }
}]);
