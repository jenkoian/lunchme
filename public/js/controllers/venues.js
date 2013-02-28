'use strict';

lunchMeApp.controller('VenuesController', ['$scope', '$resource', function($scope, $resource) {

   $scope.venues = $resource("/venues").query();
}]);
