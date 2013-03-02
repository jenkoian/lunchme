'use strict';

lunchMeApp.controller('VenuesController', ['$scope', '$resource', function($scope, $resource) {

   var Venue = $resource("/venues/:id", {id: '@id'}, {
      update: {method:'PUT'}
   });

   $scope.venues = Venue.query();

   var rate = function(venue, modifier) {
      venue.rating = venue.rating != undefined ? parseInt(venue.rating) + modifier : 1;
      return venue;
   }

   $scope.uprate = function(venue) { rate(venue, 1).$update(); }
   $scope.downrate = function(venue) { rate(venue, -1).$update(); }
}]);
