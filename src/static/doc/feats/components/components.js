// database info
angular.module('quodatum.doc.components', [ 'ui.router', 'quodatum.services' ])
    .config(
        [ '$stateProvider', '$urlRouterProvider',
            function($stateProvider, $urlRouterProvider) {
              $stateProvider

              .state('component', {
                url : "/data/component",
                abstract : true,
                template : '<ui-view>library</ui-view>'
              })
              
              .state('component.index', {
                url : "",
                templateUrl : '/static/doc/feats/components/components.xhtml',
                controller : "ScrollCtrl"
              })
              
               .state('component.item', {
                url : "/:name",
                templateUrl : '/static/doc/feats/components/comp1.xhtml',
                controller : "CompCtrl"
              })
              .state('component.tree', {
                url : "/tree",
                templateUrl : '/static/doc/feats/components/cmptree.xhtml',
                controller : "CmptreeCtrl"
              })
              
              .state('component.basex', {
                url : "/basex",
                templateUrl : '/static/doc/feats/components/basex.xhtml',
                controller : "BasexCtrl"
              })
              .state('component.basex.module', {
                url : "?module",
                templateUrl : '/static/doc/feats/components/basex.xhtml',
                controller : "BasexCtrl"
              })
            } ])

    .factory('API', [ '$resource', "apiRoot", function($resource, apiRoot) {
      return {
        basex : $resource(apiRoot + 'components/basex')
      }
    } ])

    // controllers
    .controller("CmptreeCtrl", [ '$scope', function($scope) {
      console.log("svg here");
    } ])

     // controllers
    .controller("CompCtrl", [ '$scope', function($scope) {
      console.log("CompCtrl");
    } ])
    
    // show BaseX system modules
    .controller(
        "BasexCtrl",
        [ '$scope', '$stateParams', 'API', 'ScrollService',
            function($scope, $stateParams, API, ScrollService) {
              console.log("BasexCtrl");
              $scope.module = $stateParams.module;
              $scope.isModule = !!$scope.module;
              if (!$scope.isModule) {
                $scope.results = API.basex.query();
                $scope.module = "admin.xqm"
              }
              ;
              $scope.scrollTo = ScrollService.scrollTo;

            } ]);
