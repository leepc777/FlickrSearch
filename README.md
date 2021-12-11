# FlickrSearch

## Main Features
* Search and display Flickr photos
* Display full size photos
* Zoom in and Zoom out a photo


## Main Goals:

* Interact with **RESTful** Flickr API
* **GCD**, **multi-threaded** and **asynchronous codes** for internet access.
* Use **NSCache** to cache downloaded images to improve performance.
* use **Instrument** to confirm **60FPS** performance.
* **Unit Tests** to test API : RequestURL is properly generated and successfully asynchronously download image through Flicr API

## Resource
* Flickr API Document ([here](https://www.flickr.com/services/api/))
* Request Flickr **API Key** (You need an API Key. [here](https://www.flickr.com/services/api/misc.api_keys.html)) 
* Flickr API method for this APP is **flickr.photos.search** (details [here](https://www.flickr.com/services/api/flickr.photos.search.html)) 
* **SwiftyJSON** to parse JSON ( copy SwiftyJSON.swift to your project [here](https://github.com/SwiftyJSON/SwiftyJSON/tree/master/Source))
