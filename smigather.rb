#!/usr/bin/env ruby
# coding: utf-8
#
# smigather.rb
# Author: Seorenn
#
# This script gathering subtitle files in subdirectories (only 1 depth)
#   to current directory.
# And Delete blank directory.
#

$pwd = Dir.pwd
$targets = [ "smi", "SMI", "smil", "SMIL" ]

require "fileutils"

def deletetrash(a)
    a.delete "."
    a.delete ".."
    a
end

def removeblankdir(dir)
    files = deletetrash Dir.entries dir
    if files.length <= 0
        puts "Remove black directory #{dir}"
        FileUtils.rmdir dir
    end
end

def gatherfiles(dir)
    files = deletetrash Dir.entries dir
    files.each do |file|
        extnames = file.split "."
        next if extnames.length < 2 || 
                $targets.include?(extnames[-1]) == false
        
        srcfile = File.join dir, file
        puts "Moving file #{file} to current directory..."

        # move file to current directory

        begin
            FileUtils.mv srcfile, $pwd
        rescue
            puts "Failed to move file #{file}."
            next
        end
    end

    removeblankdir dir
end

# discover directories in current directory
def discover
    allfiles = deletetrash Dir.entries $pwd
    allfiles.each do |filename|
        if File.directory?(filename) then
            targetdir = File.join $pwd, filename
            gatherfiles targetdir
        end
    end
end

puts "Starting gather subtitle files..."

discover
