'use strict'

angular.module 'imageUpload', []

angular.module('imageUpload')
  .directive 'imageUpload', ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the imageUpload directive'