# Mappple

**Google Maps +  [Dribbble][dribbble] = [Mappple](http://mappple.matiaskorhonen.fi)**

The location for each shot is determined by the Dribbble Player's
location (as set in their profile). Unfortunately this also has the
effect that some markers on the map may overlap.

Geocoding of the Players' locations is done using the Google Maps
Geocoding API with a fallback to the [GeoNames][geonames] geocoding
API.

Results from the Geocoding are stored using [localStorage][storage]
where supported (and with appropriate fallbacks via
[store.js][storejs]).

The HTML and CSS was done using [HAML][haml] and [SCSS][scss],
respectively, and the JavaScript was created with
[CoffeeScript][cs]. I mostly code in Ruby and I've never used
CoffeeScript before, so the resulting JS might be awful and full of JS
anti-patterns. Or then again it might not.

[cs]: http://coffeescript.org/
[dribbble]: http://dribbble.com/
[geonames]: http://www.geonames.org/
[haml]: http://haml-lang.com/
[scss]: http://sass-lang.com/
[storage]: https://developer.mozilla.org/en/dom/storage#localStorage
[storejs]: https://github.com/marcuswestin/store.js

## Usage

* Run `bundle install` to install the required dependencies.
* Copy the `sample_config.yaml` file to `config.yaml` to configure the site.
* Run `bundle exec rake auto` to autocompile the site and start the development server.
* Use `bundle exec rake -T` for further information on how to generate the site.

## License & copyright

Copyright (C) 2011 by Matias Korhonen

Licensed under the MIT license, for more information see the LICENSE file.
