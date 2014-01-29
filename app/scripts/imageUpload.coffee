'use strict'

angular.module 'imageUpload', []

angular.module('imageUpload')
  .directive 'imageUpload', ($http) ->
    scope: 
      imageUpload: '='
    template: ' <div class="fileUpload">
                  <div class="fileUploadImage"></div>
                  <form enctype="multipart/form-data">
                    <input type="file" name="file" ng-disabled="!imageUpload.enabled" title="&#8203;" />
                  </form>
                  <div class="fileUpload-loading"></div>
                </div>'
    link: (scope, element, attrs) ->
      image = new Image

      image.onload  = -> 
        element.find('.fileUploadImage').append image
      image.onerror = -> 
        image.src = scope.imageUpload.placeholder

      # Update photo url
      scope.$watch 'imageUpload.read', ->
        if scope.imageUpload.read?
          image.src = scope.imageUpload.read
        else 
          image.src = 'broken'

      # Reset the uploader
      reset = ->
        # Hide the loading symbol
        element.find('.fileUpload-loading').css
          display: 'none'

        # Empty the upload field
        element.find('input').val ''

        # Update the image
        return unless scope.imageUpload.read?
        image.src = "#{scope.imageUpload.read}?#{Math.random()}"

      reset()

      # Style the things
      element.find('.fileUpload').css
        position: 'relative'
        width:    '100%'
        height:   '100%'

      element.find('form, input, .fileUpload-loading').css
        position: 'absolute'
        top:      '0'
        right:    '0'
        overflow: 'hidden'
        margin:   '0'
        padding:  '0'
        opacity:  '0'
        width:    '100%'
        height:   '100%'
        cursor:   'default'

      element.find('.fileUpload-loading').css
        background: 'white url(images/loading.gif) center center no-repeat'
        opacity:    '0.6'

      error = (response) ->
        # Reset the uploader
        reset()

        # Trigger error callback
        scope.$eval scope.imageUpload.error, response

      # Once a file has been selected
      element.find('input').bind 'change', ->
        # Show the loading symbol
        element.find('.fileUpload-loading').css
          display: 'block'

        data = new FormData angular.element('form')[0]

        options = 
          withCredentials:  true
          cache:            false
          headers:          'Content-Type': undefined
          transformRequest: angular.identity

        $http.put(scope.imageUpload.write, data, options)
          .success(reset).error(error)