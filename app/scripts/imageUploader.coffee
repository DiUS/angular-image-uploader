'use strict'

angular.module 'imageUploader', []

angular.module('imageUploader')
  .directive 'imageUploader', ($http) ->
    scope: 
      imageUploader: '='
    template: ' <div class="fileUpload">
                  <div class="fileUploadImage"></div>
                  <form enctype="multipart/form-data">
                    <input type="file" name="file" ng-disabled="!imageUploader.enabled" title="&#8203;" />
                  </form>
                  <div class="fileUpload-loading"></div>
                </div>'
    link: (scope, element, attrs) ->
      image = new Image

      image.onload  = -> 
        imageElement = angular.element element[0].querySelector('.fileUploadImage')
        imageElement.append image
      image.onerror = -> 
        image.src = scope.imageUploader.placeholder

      # Update photo url
      scope.$watch 'imageUploader.read', ->
        if scope.imageUploader.read?
          image.src = scope.imageUploader.read
        else 
          image.src = 'broken'

      # Reset the uploader
      reset = ->
        # Hide the loading symbol
        loadingElement = angular.element element[0].querySelector('.fileUpload-loading')
        loadingElement.css display: 'none'

        # Empty the upload field
        element.find('input').val ''

        # Update the image
        return unless scope.imageUploader.read?
        image.src = "#{scope.imageUploader.read}?#{Math.random()}"

      reset()

      # Style the things
      fileUploadElement = angular.element element[0].querySelector('.fileUpload')
      fileUploadElement.css
        position: 'relative'
        width:    '100%'
        height:   '100%'

      nestedElements = angular.element element[0].querySelectorAll('form, input, .fileUpload-loading')
      nestedElements.css
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

      loadingElement = angular.element element[0].querySelector('.fileUpload-loading')
      loadingElement.css
        background: 'white url(images/loading.gif) center center no-repeat'
        opacity:    '0.6'

      error = (response) ->
        # Reset the uploader
        reset()

        # Trigger error callback
        scope.$eval scope.imageUploader.error, response

      # Once a file has been selected
      element.find('input').bind 'change', ->
        # Show the loading symbol
        loadingElement = angular.element element[0].querySelector('.fileUpload-loading')
        loadingElement.css display: 'block'

        data = new FormData element.find('form')[0]

        options = 
          withCredentials:  true
          cache:            false
          headers:          'Content-Type': undefined
          transformRequest: angular.identity

        $http.put(scope.imageUploader.write, data, options)
          .success(reset).error(error)