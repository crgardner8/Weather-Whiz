# Weather-Whiz

WeatherWhiz is a local weather app that takes advantage of the DarkSky API to get temperature and forcast information. Upon launch the app displays weather information based on the device's current location. Pressing the Change City button navigates to a City Selection screen, where the user can; add a new city to the city list, or select a city from the current list. Upon selecting a city, the user navigates back to the main screen where the weather of the selected city is shown. If no city is shown, the weather for the last coordinates are refreshed and displayed. 

CoreLocation is used to get the current location of the device. CLGeocoder is used to reverse Geocode a location and the Geocode an address string (reverseGeocodeLocation: and geocodeAddressString). This allows the app to get the City and State from the latitude and longitude that the DarkSky API provides, and also allows the app to get the latitude and longitude from the City and State the user provides on the city selection screen.

NSURLSession is the ios standard for webServices. That is no different in WeatherWhiz. 

The UI was laid out in a simplistic way, so that the data is easy to understand. The code was also done in a way that would be easy to grasp. 
