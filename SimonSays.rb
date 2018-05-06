#!/bin/env ruby

require 'gosu'
require 'yaml'

require 'awesome_print'
require 'byebug'

ROOT = File.expand_path(File.dirname(__FILE__))

DIR = {
	src:      File.join(ROOT, 'src'),
	settings: File.join(ROOT, 'settings.yml')
}

require File.join DIR[:src], 'extensions'
require File.join DIR[:src], 'Settings'
require File.join DIR[:src], 'Field'
require File.join DIR[:src], 'Board'
require File.join DIR[:src], 'Game'
