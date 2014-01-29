(function() {
  'use strict';
  angular.module('imageUploader', []);

  angular.module('imageUploader').directive('imageUploader', function($http) {
    return {
      scope: {
        imageUploader: '='
      },
      template: ' <div class="fileUpload">\
                  <div class="fileUploadImage"></div>\
                  <form enctype="multipart/form-data">\
                    <input type="file" name="file" ng-disabled="!imageUploader.enabled" title="&#8203;" />\
                  </form>\
                  <div class="fileUpload-loading"></div>\
                </div>',
      link: function(scope, element, attrs) {
        var error, fileUploadElement, image, loadingElement, nestedElements, reset;
        image = new Image;
        image.onload = function() {
          var imageElement;
          imageElement = angular.element(element[0].querySelector('.fileUploadImage'));
          return imageElement.append(image);
        };
        image.onerror = function() {
          return image.src = scope.imageUploader.placeholder;
        };
        scope.$watch('imageUploader.read', function() {
          if (scope.imageUploader.read != null) {
            return image.src = scope.imageUploader.read;
          } else {
            return image.src = 'broken';
          }
        });
        reset = function() {
          var loadingElement;
          loadingElement = angular.element(element[0].querySelector('.fileUpload-loading'));
          loadingElement.css({
            display: 'none'
          });
          element.find('input').val('');
          if (scope.imageUploader.read == null) {
            return;
          }
          return image.src = "" + scope.imageUploader.read + "?" + (Math.random());
        };
        reset();
        fileUploadElement = angular.element(element[0].querySelector('.fileUpload'));
        fileUploadElement.css({
          position: 'relative',
          width: '100%',
          height: '100%'
        });
        nestedElements = angular.element(element[0].querySelectorAll('form, input, .fileUpload-loading'));
        nestedElements.css({
          position: 'absolute',
          top: '0',
          right: '0',
          overflow: 'hidden',
          margin: '0',
          padding: '0',
          opacity: '0',
          width: '100%',
          height: '100%',
          cursor: 'default'
        });
        loadingElement = angular.element(element[0].querySelector('.fileUpload-loading'));
        loadingElement.css({
          background: 'white url(images/loading.gif) center center no-repeat',
          opacity: '0.6'
        });
        error = function(response) {
          reset();
          return scope.$eval(scope.imageUploader.error, response);
        };
        return element.find('input').bind('change', function() {
          var data, options;
          loadingElement = angular.element(element[0].querySelector('.fileUpload-loading'));
          loadingElement.css({
            display: 'block'
          });
          data = new FormData(element.find('form')[0]);
          options = {
            withCredentials: true,
            cache: false,
            headers: {
              'Content-Type': void 0
            },
            transformRequest: angular.identity
          };
          return $http.put(scope.imageUploader.write, data, options).success(reset).error(error);
        });
      }
    };
  });

}).call(this);
