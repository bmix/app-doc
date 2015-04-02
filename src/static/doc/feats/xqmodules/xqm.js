// app info
angular.module('quodatum.doc.xqm', [ 'restangular','quodatum.services' ])

.config([ '$routeProvider', function($routeProvider) {
	$routeProvider.when('/data/app', {
		templateUrl : '/static/doc/feats/apps/apps.xhtml',
		controller : "XqmsCtrl"
	}).when('/data/app/:app', {
		templateUrl : '/static/doc/feats/apps/app1.xhtml',
		controller : "XqmCtrl"	
	}).when('/data/app/:app/:view', {
		templateUrl : '/static/doc/feats/apps/app-view.xhtml',
		controller : "XqmCtrl2"
	});

} ])


// controllers
.controller("XqmsCtrl",
		[ "$scope", "Restangular", function($scope, Restangular) {

			console.log("XqmCtrl2");
			var bar = Restangular.one("meta").one("cvabar","apps-bar");
			bar.get().then(function(d) {
				$scope.bar = d;
			});
			var applist = Restangular.one("data").all('app');
			applist.getList().then(function(d) {
				//console.log("AppsCtrl2", d);
				$scope.apps = d;
			});

		} ])

.controller(
		"XqmCtrl",
		[ "$scope", "$routeParams", "Restangular",
				function($scope, $routeParams, Restangular) {				
					var app = $routeParams.app;
					console.log("AppCtrl",app);
					
					var applist = Restangular.one("data").one('app',app);
					applist.get().then(function(d) {
						$scope.app = d.item;
						console.log(">>",d);
					});
					var bar = Restangular.one("meta").one("cvabar","app-bar");
					bar.get().then(function(d) {
						$scope.bar = d;
					});
				} ])

.controller(
		'XqmCtrl2',
		[ "$scope", "$routeParams", "ScrollService", "$log","$location",
				function($scope, $routeParams, ScrollService, $log,$location) {
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
					var searchObject = $location.search(); // {path:"dd",type:"basex"}
					console.log("search:",searchObject);
					var target = "../../doc/app/"+app +map[$routeParams.view];
					if(searchObject.path){
						target+="?path="+$routeParams.path;
					}
					if(searchObject.type){
						target+="&type="+searchObject.type;
					}
					$scope.inc = target;
					console.log("TAR",target);
					$scope.setTitle("docs");
					$scope.scrollTo = ScrollService.scrollTo;
				} ]);
