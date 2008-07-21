#
#  ShaneApp.rb
#  ShaneNotes
#
#  Created by Patrick Hurley on 7/19/08.
#  Copyright (c) 2008 HurleyHome LLC. All rights reserved.
#

require 'osx/cocoa'
require 'pp'

class ShaneApp < OSX::NSObject
  ib_outlet :menu

  def applicationDidFinishLaunching(sender)
      statusbar = OSX::NSStatusBar.systemStatusBar 
      item = statusbar.statusItemWithLength(OSX::NSVariableStatusItemLength) 
      image = OSX::NSImage.alloc.initWithContentsOfFile("/Users/phurley/projects/ShaneNotes/smile.tiff") 
      item.setImage(image) 

      item.setMenu(@menu) 
  end

  class << self
    def notesdir
      dir = File.join(ENV['HOME'], "Library", "Application Support", "ShaneNotes")
      Dir.mkdir(dir) rescue nil
      dir
    end
    
    def rescan
      @files = nil
    end
    
    def files
      @files ||= Dir.glob(File.join(notesdir, "*.rtf"))
    end
    
    def mkfname(fname)
      fname = File.basename(fname, ".rtf")
      File.join(notesdir, fname + ".rtf")
    end
    
  end
  
end

