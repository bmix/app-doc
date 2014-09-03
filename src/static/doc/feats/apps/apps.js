// app info
angular.module('quodatum.doc.apps', [ 'restangular' ])

.config([ '$routeProvider', function($routeProvider) {
	console.log("$routeProvider quodatum.doc.apps");
	$routeProvider.when('/apps', {
		templateUrl : '/static/doc/feats/apps/apps.xhtml',
		controller : "AppsCtrl"
	}).when('/apps/:app', {
		redirectTo: "/apps/:app/wadl"		
	}).when('/apps/:app/:view', {
		templateUrl : '/static/doc/feats/apps/app1.xhtml',
		controller : "AppCtrl"
	});

} ])

.run([ "$rootScope","$window", function($rootScope, $window) {
	$rootScope.setTitle = function(t) {
		$window.document.title = t;
	};
} ])

// controllers
.controller("AppsCtrl",
		[ "$scope", "Restangular", function($scope, Restangular) {

			console.log("AppsCtrl2");
			var applist = Restangular.one("data").all('app');
			applist.getList().then(function(d) {
				console.log("AppsCtrl2", d);
				$scope.apps = d;
			});

		} ])

.controller(
		"AppCtrl",
		[ "$scope", "$routeParams", "Restangular",
				function($scope, $routeParams, Restangular) {
					console.log("AppsCtrl");
					var item = $routeParams.app;
					var applist = Restangular.one("data").all('app');
					applist.getList().then(function(d) {
						console.log("AppsCtrl", d);
						$scope.apps = d;
					});

				} ])

.controller(
		'AppCtrl',
		[ "$scope", "$routeParams", "$location", "$anchorScroll", "$log",
				function($scope, $routeParams, $location, $anchorScroll, $log) {
					$log.log("View:", $routeParams.view);
					var app = $routeParams.app;
					var map = {
						"xqdoc" : '/server/xqdoc',
						"wadl" : '/server/wadl',
						"components" : '/client/components',
						"templates" : '/client/templates',
						"xqdoc2" : 'doc/server'
					};
					$scope.view = $routeParams.view;
					$scope.app = $routeParams.app;
					$scope.inc = "/doc/app/"+app +map[$routeParams.view];
					$scope.setTitle("docs");
					$scope.scrollTo = function(id) {
						$log.log("DDDD", id);
						$location.hash(id);
						// call $anchorScroll()
						$anchorScroll();
					};
				} ]);