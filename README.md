angular-image-uploader
======================

Upload images in an elegant way with this AngularJS directive.

how it works
------------
A form is hidden behind the image you choose to display. The user can click on the image, which 
allows them to select a new image file and upload to the url chosen. The image will automatically 
replace itself once the image has been uplaoded successfully. This is all done asynchronously.

Developers can also set their own loading symbol and error handling if they so choose to.

browser support
---------------
Tested and verified to work in Google Chrome & Safari.

dependencies
------------
This directive is jQuery free.

install
-------

```
bower install angular-image-uploader
```

usage
-----

Make sure you include the module in your application config

```javascript
angular.module('myApp', [
  'imageUploader',
  //...
]);
```

Provide options in your controller.
```javascript
angular.module('myApp').controller('ImageCtrl', function ($scope) {
  $scope.imageOptions = {
    read: /*<url_to_read_image_from>*/,
    write: /*<url_to_write_image_to>*/,
    enabled: true,
    error: function (event, response) {
      console.log('error, ', response);
    },
    success: function (event, response) {
      console.log('success, ', response);
    }
  };
});
```

And use the directive
```html
<div image-uploader="imageOptions"></div>
```

If you would like to have a loading symbol while the upload is happening, you can simply use css
```javascript
.fileUpload .fileUpload-loading {
  background: //...
}
```

