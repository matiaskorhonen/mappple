# encoding: UTF-8
require "coffee_script"

class CoffeeFilter < Nanoc3::Filter
  identifier :coffee

  def run(content, params = {})
    CoffeeScript.compile(content)
  end
end