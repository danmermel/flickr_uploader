flickr_uploader
===============

This is a simple Ruby script to upload photos to Flickr using their API.

Background
----------

Flickr give you 1 TB of storage and a lot of control over the privacy of your files, so I decided to use it as my photo storage facility. I wrote this script to upload my pictures to it. And it basically worked... I uploaded 13,000 pictures to Flickr with it.

Instructions
------------

Get a Flickr user and an API key. http://www.flickr.com/services/api/

Install the Flickraw gem (https://github.com/hanklords/flickraw) and follow his instructions to authenticate your "app" so that you can obtain all the necessary tokens and secrets. Put these in the script.

Your photos need to be in folders. When it runs, the script will look for any folders in the directory in which it is running and loop through each one looking for photos to upload. After it uploads all the photos in the folder it will create a Flickr set with the folder name and assign all the uploaded photos to that set.

It will try not to create any duplicate set names (but beware because I think the Flickr API only returns up to 500 sets in a "get sets" call, so things may go pear shaped if you have more that that.


Warnings
--------

This is a very simplistic thing. It worked for me. I hope you can use it too.

It deletes pics from the folder after successful upload. If you want to keep a copy, put them somewhere else as well!

The Flickr API will error randomly, i.e. a photo may fail to upload once and then be fine the next time. So basically you have to run the script many times before all photos get uploaded. The script will try not to crash with the most obvious errors.





