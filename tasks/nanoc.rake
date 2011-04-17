require "rake/clean"
CLEAN.include("public/**")

desc "Compile site HTML using nanoc."
task :compile do
  system "bundle execnanoc3 compile"
end

desc "Start the nanoc autocompiler."
task :auto do
  system "bundle exec nanoc3 autocompile -H thin -p 3000"
end

desc "Start the nanoc autocompiler in the background."
task :quiet do
  system "bundle exec nanoc3 autocompile -H thin -p 3000 > log/autocompile.log 2>&1 &"
end