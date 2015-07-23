angular.module(
    'doc',
    [ 'ui.router', 'ngResource', 'ngAnimate','ngSanitize', 'ui.bootstrap', 'restangular',
        'ya.treeview', 'ya.treeview.tpls', 'angular-growl', 'ncy-angular-breadcrumb',
		'quodatum.entity',
        'quodatum.doc.apps', 'quodatum.doc.components', 'quodatum.doc.files',
        'quodatum.doc.xqm', 'quodatum.doc.schema', 'quodatum.doc.directives',
        'quodatum.doc.tools', 'quodatum.directives', 'quodatum.config' ])

.constant("apiRoot", "../../doc/")

.config(
    [ '$stateProvider', '$urlRouterProvider',
        function($stateProvider, $urlRouterProvider) {
          $stateProvider
		  
          .state('home', {
            url : "",
            controller : "HomeCtrl"
          })
		  
          .state('search', {
            url : "/search",
            templateUrl : '/static/doc/templates/search.xhtml',
            controller : "SearchCtrl"
          })

          .state('error', {
            url : "/error",
            templateUrl : '/static/doc/templates/error.xhtml'
          })

          .state('about', {
            url : "/about",
            templateUrl : '/static/doc/templates/about.xhtml',
			 ncyBreadcrumb: { label: 'Home',icon:'glyphicon glyphicon-home'}
          })

          .state('404', {
            url : "/404",
            templateUrl : '/static/doc/templates/404.xhtml'
          });
        //  $urlRouterProvider.when('', '/about');  
          $urlRouterProvider.otherwise('/404');  
          // use the HTML5 History API
          // $locationProvider.html5Mode(true);
        } ])
		
.controller("HomeCtrl",
    [ "$scope", "$location", function($scope, $location) {
      console.log("HomeCtrl");
     $location.path('/about')
    } ])
	
.controller("AppController",
    [ "$scope", "$location", function($scope, $location) {
      console.log("AppController");
      $scope.search = {};
      $scope.doSearch = function() {
        $location.path("/search").search({
          q : $scope.search.q
        });
      };
    } ])

.controller(
    "SearchCtrl",
    [ 'Restangular', '$location', '$scope', '$stateParams',
        function(Restangular, $location, $scope, $stateParams) {
          console.log("Search", $stateParams);
          $scope.q = $stateParams.q;
          function search(q) {
            Restangular.all("search").getList({
              q : $scope.q
            }).then(function(d) {
              console.log(d);
              $scope.results = d;
            })
          }
          ;

          $scope.submit = function() {
            $location.path("/search");
          };
          $scope.doSearch = function() {
            search($scope.q);
          };
          search($scope.q);
        } ])
// information about entity
.factory('Entities', [ function() {
  console.log("entities");
  var ents = {
    "database" : [ {
      label : "name",
      field : "name"
    }, {
      label : "resources",
      field : "resources"
    }, {
      label : "updated",
      field : "updated"
    }, {
      label : "path",
      field : "path"
    } ],
    "model" : [ {
      label : "name",
      field : "name"
    }, {
      label : "type",
      field : "type"
    }, {
      label : "#field",
      field : "nfields"
    } ],
    "package" : [ {
      label : "name",
      field : "name"
    }, {
      label : "type",
      field : "type"
    } ],
    "resource" : [ {
      label : "name",
      field : "name"
    }, {
      label : "raw",
      field : "raw"
    }, {
      label : "modifiedDate",
      field : "modifiedDate"
    }, {
      label : "contentType",
      field : "contentType"
    } ],
    "log" : [ {
      label : "date",
      field : "date"
    }, {
      label : "size",
      field : "size"
    } ],
    "logentry" : [ {
      label : "Time",
      field : "time"
    }, {
      label : "Address",
      field : "address"
    }, {
      label : "User",
      field : "user"
    }, {
      label : "Type",
      field : "type"
    }, {
      label : "Ms",
      field : "ms"
    }, {
      label : "Message",
      field : "message"
    } ],
    "session" : [ {
      label : "id",
      field : "id"
    }, {
      label : "accessed",
      field : "accessed"
    }, {
      label : "created",
      field : "created"
    }, {
      label : "count",
      field : "count"
    } ],
    "endpoint" : [ {
      label : "path",
      field : "path"
    }, {
      label : "method",
      field : "method"
    }, {
      label : "doc",
      field : "doc"
    }, {
      label : "mediatype",
      field : "mediatype"
    } ],
    "xqmodule" : [ {
      label : "name",
      field : "name"
    }, {
      label : "description",
      field : "description"
    } ]
  };
  return {
    // sortable columns
    columns : function(entity) {
      return ents[entity]
    }
  }
} ]);
