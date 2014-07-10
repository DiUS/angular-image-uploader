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

      # Update photo url
      scope.$watch 'imageUploader.read', ->
        image.src = scope.imageUploader.read || ''

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

      success = (response) ->
        # Reset the uploader
        reset()

        # Trigger success callback
        scope.$eval scope.imageUploader.success, response

      # Once a file has been selected
      element.find('input').bind 'change', ->
        # Show the loading symbol
        loadingElement = angular.element element[0].querySelector('.fileUpload-loading')
        loadingElement.css display: 'block'

        file = element.find('input')[0].files[0]

        fileReader = new FileReader()

        if file.size > 1048576
          fileReader.onload = (e) ->
            img = new Image()
            img.onload = ->
              max = 600
              r = max / this.height
              w = Math.round(this.width * r)
              h = Math.round(this.height * r)
              c = document.createElement("canvas")
              c.width = w
              c.height = h
              c.getContext("2d").drawImage(this, 0, 0, w, h)
              formData = new FormData()
              formData.append('file', c.toDataURL())
              upload(formData)
            img.src=e.target.result
          fileReader.readAsDataURL(file)
        else
          fileReader.onload = (e) ->
            formData = new FormData()
            formData.append('file', e.target.result)
            upload(formData)
          fileReader.readAsDataURL(file)

      upload = (formData) ->
        options =
          withCredentials:  true
          cache:            false
          headers:          'Content-Type': undefined
          transformRequest: angular.identity

        $http.put(scope.imageUploader.write, formData, options)
          .success(success).error(error)
