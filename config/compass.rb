# This is the Compass configuration file. The configuration file for nanoc is 
# named “config.yaml”.

project_path = File.join(File.dirname(__FILE__), '..')
http_path    = '/'
output_style = :compressed
css_dir      = "output/stylesheets" 
sass_dir     = "content/stylesheets" 
images_dir   = "output/images"

# when using SCSS:
sass_options = {
  :syntax => :scss
}