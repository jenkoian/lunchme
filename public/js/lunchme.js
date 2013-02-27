'use strict';

var lunchMeApp = angular.module('lunchMeApp', ['ngResource'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/venues.html',
        controller: 'VenuesController'
      })
      .otherwise({
        redirectTo: '/'
      });
  }]);
