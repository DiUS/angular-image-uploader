'use strict'

describe 'Directive: imageUploader', ->

  beforeEach module 'imageUploader'

  $http   = null
  scope   = {}
  element = null

  beforeEach inject ($rootScope, $window, _$http_) ->
    scope = $rootScope.$new()
    scope.imageOptions = {}
    $http = _$http_

  describe 'rendering', ->
    beforeEach inject ($compile) ->
      element = angular.element '<div image-uploader="imageOptions"></div>'
      element = $compile(element)(scope)[0]

    it 'should render the template', ->
      expect(element.querySelector('.fileUpload')).not.toBeNull()

    it 'should render a form', ->
      expect(element.querySelector('form')).not.toBeNull()

    it 'should be a multipart form', ->
      expect(element.querySelector('form').getAttribute('enctype')).toBe 'multipart/form-data'

    it 'should have a file input', ->
      inputElement = angular.element element.querySelector('form input')
      expect(inputElement.attr('type')).toBe 'file'
      expect(inputElement.attr('name')).toBe 'file'

    it 'should set the file input title to a hidden character', ->
      inputElement = angular.element element.querySelector('form input')
      expect(inputElement.attr('title').length).toBe 1
      expect(inputElement.attr('title').trim()).toBe ''

    it 'should disable the input if option to do so is given', ->
      inputElement = angular.element element.querySelector('form input')
      expect(inputElement.attr('disabled')).not.toBe 'disabled'
      scope.imageOptions.enabled = false
      scope.$digest()
      expect(inputElement.attr('disabled')).toBe 'disabled'


    it 'should render an image', ->
      expect(element.querySelector('.fileUploadImage')).not.toBeNull()
      
    it 'should render a loading element', ->
      expect(element.querySelector('.fileUpload-loading')).not.toBeNull()

  describe 'initialise and reset', ->
    beforeEach inject ($compile) ->
      element = angular.element '<div image-uploader="imageOptions"></div>'
      scope.imageOptions.read = 'https://www.google.com/images/srpr/logo11w.png'

      element = $compile(element)(scope)[0]

    it 'should not display the loading element', ->
      loadingElement = angular.element element.querySelector('.fileUpload-loading')
      expect(loadingElement.css('display')).toBe 'none'

    it 'should not have a file input value', ->
      inputElement = angular.element element.querySelector('form input')
      expect(inputElement.val()).toBe ''

    it 'should insert the initial read image', ->
      imageElement = null

      runs ->
        imageElement = angular.element element.querySelector('.fileUploadImage')

      waitsFor ->
        imageElement.find('img').attr('src') != undefined
      , 2000, 'image source to be set'

      runs ->
        expect(imageElement.find('img').attr('src')).toMatch scope.imageOptions.read

  describe 'when read url changes', ->
    beforeEach inject ($compile) ->
      element = angular.element '<div image-uploader="imageOptions"></div>'
      element = $compile(element)(scope)[0]

    describe 'if the read url is empty', ->
      beforeEach ->
        scope.imageOptions.read = null
        scope.$digest()

      it 'should set the image url to be empty', ->
        imageElement = angular.element element.querySelector('.fileUploadImage')
        expect(imageElement.find('img').attr('src')).toBeUndefined()

    describe 'if the read url is set', ->
      beforeEach ->
        scope.imageOptions.read = 'https://www.google.com/images/srpr/logo11w.png'
        scope.$digest()

      it 'should update the image url', ->
        imageElement = null

        runs ->
          imageElement = angular.element element.querySelector('.fileUploadImage')

        waitsFor ->
          imageElement.find('img').attr('src') != undefined
        , 2000, 'image source to be set'

        runs ->
          expect(imageElement.find('img').attr('src')).toBe scope.imageOptions.read

  describe 'styling', ->
    beforeEach inject ($compile) ->
      element = angular.element '<div image-uploader="imageOptions"></div>'
      element = $compile(element)(scope)[0]

    it 'should style the element', ->
      fileUploadElement = angular.element element.querySelector('.fileUpload')
      expect(fileUploadElement.css('position')).toBe 'relative'
      expect(fileUploadElement.css('width')).toBe    '100%'
      expect(fileUploadElement.css('height')).toBe   '100%'

    it 'should style the form', ->
      formElement = angular.element element.querySelector('form')
      expect(formElement.css('position')).toBe 'absolute'
      expect(formElement.css('top')).toBe      '0px'
      expect(formElement.css('right')).toBe    '0px'
      expect(formElement.css('overflow')).toBe 'hidden'
      expect(formElement.css('margin')).toBe   '0px'
      expect(formElement.css('padding')).toBe  '0px'
      expect(formElement.css('opacity')).toBe  '0'
      expect(formElement.css('width')).toBe    '100%'
      expect(formElement.css('height')).toBe   '100%'
      expect(formElement.css('cursor')).toBe   'default'

    it 'should style the input', ->
      inputElement = angular.element element.querySelector('form input')
      expect(inputElement.css('position')).toBe 'absolute'
      expect(inputElement.css('top')).toBe      '0px'
      expect(inputElement.css('right')).toBe    '0px'
      expect(inputElement.css('overflow')).toBe 'hidden'
      expect(inputElement.css('margin')).toBe   '0px'
      expect(inputElement.css('padding')).toBe  '0px'
      expect(inputElement.css('opacity')).toBe  '0'
      expect(inputElement.css('width')).toBe    '100%'
      expect(inputElement.css('height')).toBe   '100%'
      expect(inputElement.css('cursor')).toBe   'default'

    it 'should style the loading element', ->
      loadingElement = angular.element element.querySelector('.fileUpload-loading')
      expect(loadingElement.css('position')).toBe  'absolute'
      expect(loadingElement.css('top')).toBe       '0px'
      expect(loadingElement.css('right')).toBe     '0px'
      expect(loadingElement.css('overflow')).toBe  'hidden'
      expect(loadingElement.css('margin')).toBe    '0px'
      expect(loadingElement.css('padding')).toBe   '0px'
      expect(loadingElement.css('opacity')).toBe   '0.6'
      expect(loadingElement.css('width')).toBe     '100%'
      expect(loadingElement.css('height')).toBe    '100%'
      expect(loadingElement.css('cursor')).toBe    'default'
      expect(loadingElement.css('background')).toBe 'url(http://localhost:8080/images/loading.gif) 50% 50% no-repeat white'
  
  describe 'when a file is uploaded', ->
    success = null
    error   = null
    firstImageUrl = null

    beforeEach inject ($compile) ->
      element = angular.element '<div image-uploader="imageOptions"></div>'
      scope.imageOptions.read  = 'https://www.google.com/images/srpr/logo11w.png'
      scope.imageOptions.write = 'http://my.write.url'
      element = $compile(element)(scope)[0]

      # get first image url
      imageElement = null

      runs ->
        imageElement = angular.element element.querySelector('.fileUploadImage')

      waitsFor ->
        imageElement.find('img').attr('src') != undefined
      , 2000, 'image source to be set'

      runs ->
        firstImageUrl = imageElement.find('img').attr('src')

      # Chaining with http put
      error   = jasmine.createSpy('error')
      success = jasmine.createSpy('success').andReturn
        error: error
      spyOn($http, 'put').andReturn success: success

      inputElement = angular.element element.querySelector('form input')
      inputElement.triggerHandler 'change'

    it 'should display the loading element', ->
      loadingElement = angular.element element.querySelector('.fileUpload-loading')
      expect(loadingElement.css('display')).toBe 'block'

    it 'should call http put', ->
      expect($http.put).toHaveBeenCalled()

    describe '$http.put', ->
      it 'should put to the write url provided', ->
        expect($http.put.mostRecentCall.args[0]).toBe scope.imageOptions.write

      it 'should get its data from the form', ->
        data = $http.put.mostRecentCall.args[1]
        expect(data instanceof FormData).toBeTruthy()

      it 'should pass options', ->
        expect($http.put.mostRecentCall.args[2].withCredentials).toBeTruthy()
        expect($http.put.mostRecentCall.args[2].cache).toBeFalsy()
        expect($http.put.mostRecentCall.args[2].headers['Content-Type']).toBeUndefined()
        expect($http.put.mostRecentCall.args[2].transformRequest instanceof Function).toBeTruthy()

    describe 'on success', ->
      beforeEach ->
        success.mostRecentCall.args[0]()

      it 'should hide the loading element', ->
        loadingElement = angular.element element.querySelector('.fileUpload-loading')
        expect(loadingElement.css('display')).toBe 'none'

      xit 'should reset the file input value', ->
        # impossible to test at this point, security issue with setting the val on input type=file 

      it 'should set the new image', ->
        imageElement = null

        runs ->
          imageElement = angular.element element.querySelector('.fileUploadImage')

        waitsFor ->
          imageElement.find('img').attr('src') != undefined
        , 2000, 'image source to be set'

        runs ->
          expect(imageElement.find('img').attr('src')).not.toBe firstImageUrl
          expect(imageElement.find('img').attr('src')).toMatch scope.imageOptions.read

    describe 'on error', ->
      response = 'a response'

      beforeEach ->
        scope.imageOptions.error = jasmine.createSpy('error')
        scope.$digest()
        error.mostRecentCall.args[0](response)

      it 'should hide the loading element', ->
        loadingElement = angular.element element.querySelector('.fileUpload-loading')
        expect(loadingElement.css('display')).toBe 'none'

      xit 'should reset the file input value', ->
        # impossible to test at this point, security issue with setting the val on input type=file 

      it 'should set the new image', ->
        imageElement = null

        runs ->
          imageElement = angular.element element.querySelector('.fileUploadImage')

        waitsFor ->
          imageElement.find('img').attr('src') != undefined
        , 2000, 'image source to be set'

        runs ->
          expect(imageElement.find('img').attr('src')).not.toBe firstImageUrl
          expect(imageElement.find('img').attr('src')).toMatch scope.imageOptions.read

      it 'should trigger error callback provided', ->
        expect(scope.imageOptions.error).toHaveBeenCalledWith jasmine.any(Object), response
