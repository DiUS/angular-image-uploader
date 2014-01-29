'use strict'

describe 'Directive: imageUpload', ->

  beforeEach module 'imageUpload'

  $http = null
  scope = {}

  beforeEach inject ($rootScope, _$http_) ->
    scope = $rootScope.$new()
    scope.imageOptions = {}
    $http = _$http_

  describe 'rendering', ->
    element = null

    beforeEach inject ($compile) ->
      element = angular.element '<div image-upload="imageOptions"></div>'
      element = $compile(element) scope

    it 'should render the template', ->
      expect(element[0].querySelector('.fileUpload')).not.toBeNull()

    it 'should render a form', ->
      expect(element[0].querySelector('form')).not.toBeNull()

    it 'should be a multipart form', ->
      expect(element[0].querySelector('form').getAttribute('enctype')).toBe 'multipart/form-data'

    it 'should have a file input', ->
      input = element[0].querySelector('form input')
      expect(input).not.toBeNull()
      expect(input.getAttribute('type')).toBe 'file'
      expect(input.getAttribute('name')).toBe 'file'

    it 'should render an image', ->
      expect(element[0].querySelector('.fileUploadImage')).not.toBeNull()
      
    it 'should render a loading image', ->
      expect(element[0].querySelector('.fileUpload-loading')).not.toBeNull()

  # describe