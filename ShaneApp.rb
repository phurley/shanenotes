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
end
