#!/usr/bin/env ruby
# coding: utf-8
#
# fixraws.rb
# Author: Seorenn
#
# Extract content name from file. 
# And rename that to content name.
#
# Ex. [Sample-Raws] This is Test File - 01 (this 1234 123 test).txt
#  -> This is Test File - 01.txt
#

require 'fileutils'

def convertname(name)
    r = /\[.*(-Raws|-rip|ohys)\]\s+(.*)\s+\(.*\)(\..+)/i
    match = name.match r
    if match
        return $2.strip + $3.strip.downcase
    end
end

# rule 2: '#nn' -> '- nn'
def convertname2(name)
    r = /(.*)#([0-9]+)(.*)/i
    match = name.match r
    if match
        return name.gsub(r, '\1- \2\3')
    else
        return name
    end
end

# Remove excepted names from array
def clearext(a)
    a.reject! { |item| item =~ /.*\.part/i }
    a
end

def discover
    files = clearext Dir.entries "./"
    files.delete(".")
    files.delete("..")

    files.each do |filename|
        newname = convertname filename
        next unless newname
        newname = convertname2(newname)
        puts "#{filename}\n\t-> #{newname}"
        FileUtils.mv filename, newname
    end
end

discover
