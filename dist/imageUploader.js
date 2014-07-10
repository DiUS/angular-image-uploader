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
        var error, fileUploadElement, image, loadingElement, nestedElements, reset, success, upload;
        image = new Image;
        image.onload = function() {
          var imageElement;
          imageElement = angular.element(element[0].querySelector('.fileUploadImage'));
          return imageElement.append(image);
        };
        scope.$watch('imageUploader.read', function() {
          return image.src = scope.imageUploader.read || '';
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
        success = function(response) {
          reset();
          return scope.$eval(scope.imageUploader.success, response);
        };
        element.find('input').bind('change', function() {
          var file, fileReader;
          loadingElement = angular.element(element[0].querySelector('.fileUpload-loading'));
          loadingElement.css({
            display: 'block'
          });
          file = element.find('input')[0].files[0];
          fileReader = new FileReader();
          if (file.size > 1048576) {
            fileReader.onload = function(e) {
              var img;
              img = new Image();
              img.onload = function() {
                var c, formData, h, max, r, w;
                max = 600;
                r = max / this.height;
                w = Math.round(this.width * r);
                h = Math.round(this.height * r);
                c = document.createElement("canvas");
                c.width = w;
                c.height = h;
                c.getContext("2d").drawImage(this, 0, 0, w, h);
                formData = new FormData();
                formData.append('file', c.toDataURL());
                return upload(formData);
              };
              return img.src = e.target.result;
            };
            return fileReader.readAsDataURL(file);
          } else {
            fileReader.onload = function(e) {
              var formData;
              formData = new FormData();
              formData.append('file', e.target.result);
              return upload(formData);
            };
            return fileReader.readAsDataURL(file);
          }
        });
        return upload = function(formData) {
          var options;
          options = {
            withCredentials: true,
            cache: false,
            headers: {
              'Content-Type': void 0
            },
            transformRequest: angular.identity
          };
          return $http.put(scope.imageUploader.write, formData, options).success(success).error(error);
        };
      }
    };
  });

}).call(this);
