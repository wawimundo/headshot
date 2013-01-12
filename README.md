= Headshot

Headshot is a gem that provides a quick and easy way for Ruby on Rails applications to capture users' photos via a web camera without touching ActionScript or JavaScript code. It works by embedding a Flash component in your page's view to access the user's camera and capture the user's photo. Headshot takes care of the configuration and initialization of the Flash component and other support code in your Rails application simplifying the web cam integration process.

= Sample Code

Below is some sample code to setup Headshot:

<b>Controller</b>

    class HeadshotDemoController < ApplicationController
        helper :headshot
    end

<b>View</b>

    <%= headshot_default_config(Rails.application.config.session_options[:key], headshot_capture_path) %>

    <%= headshot_camera %>

    <br/><br/>

    <%= headshot_snap_button('Shoot') %>

= Demo

Demo and complete documentation is available here:

http://headshot.hypermediasoft.com