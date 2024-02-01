# Amaze-Maze-Solver-Application

__Amaze is an application developed in MATLAB using Image Processing which can find a path between two points in a Perfect Maze (Maze with only two openings).__

![SplashImage](https://user-images.githubusercontent.com/68781375/160293047-7d39380c-1f92-425d-b573-fdd3fc31c009.JPG)

## Algorithm and its Working

__Watershed Transform:__

* _The watershed transform finds "catchment basins" or "watershed ridge lines" in an image by treating it as a surface where light pixels represent high elevations and dark pixels represent low elevations._ 

* _The watershed transform can be used to segment contiguous regions of interest into distinct objects._

* _It segements the image in parts enclosed by water paths assuming water was dropped from top of the image._

More details: https://in.mathworks.com/help/images/ref/watershed.html

## GUI Interface

![GUI-Screenshot](https://user-images.githubusercontent.com/68781375/160293382-a3da9196-0b5c-4a5b-8291-f0a8bd39c464.JPG)

## Demo Screenshots

![AppScreenshot-1](https://user-images.githubusercontent.com/68781375/160293613-1d6ef6e7-e07c-4b9a-817b-9b1395178b03.JPG)

![AppScreenshot-2](https://user-images.githubusercontent.com/68781375/160293615-7fdb7d92-0811-4d7a-893e-9982add0cb64.JPG)

![AppScreenshot-3](https://user-images.githubusercontent.com/68781375/160293621-917c600a-918f-4280-b320-ea1c4496a8f3.JPG)

## Demo Video with Explanation

https://user-images.githubusercontent.com/68781375/162617228-81e9775d-5fdf-41ed-a914-ebda9b895c88.mp4

##

__<ins>NOTE:</ins>__ 

* _There should not be any broken walls_
* _Maze should contain only two openings_
* _Walls should be seperated from the boundary of images_

__Try out different mazes on your own!!!__

