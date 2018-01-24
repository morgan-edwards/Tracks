# Tracks
Tracks is a simple light-weight Model-View-Controller (MVC) web framework
written in Ruby.

## Getting started
1. `cd` into the root directory of your project.
2. run `bundle install`
3. run `ruby bin/server.rb`
4. open your browser and go to `localhost:3000`

You should see the welcome screen, indicating the setup was successful.

## Features

### Models
  The TracksModel base class provides ORM functionality utilizing a SQLite3
  database. Through metaprogramming,
  the following methods are made available on models that inherit from TracksModel:
  `::all`
  `::find`
  `::parse_all`
  `#belongs_to`
  `#has_many`
  `#has_one_through`
  `#where`

### Controllers
The TracksController base class provides the `#render` and `#redirect_to` methods to any child class/controller. These methods automatically find the corresponding views in the `views/#{controller_name}` directory.

### Routes
  The `routes.rb` file is extensible by adding `Regexp.new` expressions representing route patterns to match urls against and the corresponding controller and method to invoke.

### Views
  Views utilize the `html.erb` formate to render dynamic HTML content dependent upon any instance variables passed to the view from a controller.

### Middleware
  HTTP requests are routed through two pieces of middleware -- `show_exceptions.rb` and `static.rb`. Show exceptions is responsible for catching runtime errors and rendering an error message and stack trace for the user. Static analyzes file extensions to determine whether the HTTP request is for a static asset, and fetches the requested file accordingly.

### Cookies
  Session persistence is achieved through the use of flash and session cookies, which can be found in `/config`.
