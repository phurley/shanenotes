#
#  ShaneApp.rb
#  ShaneNotes
#
#  Created by Patrick Hurley on 7/19/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'pp'

class ShaneApp < OSX::NSObject
  def applicationDidFinishLaunching(sender)
      statusbar = OSX::NSStatusBar.systemStatusBar 
      pp statusbar
      item = statusbar.statusItemWithLength(OSX::NSVariableStatusItemLength) 
      pp item
      image = OSX::NSImage.alloc.initWithContentsOfFile("/Users/phurley/projects/ShaneNotes/smile.tiff") 
      pp image
      item.setImage(image) 
      
      menu = OSX::NSMenu.alloc.init 
      item.setMenu(menu) 

      mitem = menu.addItemWithTitle_action_keyEquivalent( "Speak", "speak", '') 
      mitem.setTarget(self) 
      mitem = menu.addItemWithTitle_action_keyEquivalent( "Quit", "terminate:", 'q') 
      mitem.setKeyEquivalentModifierMask(OSX::NSCommandKeyMask) 
      mitem.setTarget(OSX::NSApp)     
  end
end

# set up the application delegate
$delegate = ShaneApp.alloc.init
OSX::NSApplication.sharedApplication.setDelegate($delegate)