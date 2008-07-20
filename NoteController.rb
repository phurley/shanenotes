#
#  NoteController.rb
#  ShaneNotes
#
#  Created by Patrick Hurley on 7/19/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'pp'

require 'ShaneApp.rb'

class NoteController < OSX::NSObject
  include OSX
  ib_outlet :text
  ib_outlet :combo
  ib_action :test
  
  def test
    everything = NSRange.new(0, @text.textStorage.length) 
    data = @text.RTFFromRange(everything)
  end
  
  def awakeFromNib
    load_file("test")
  end
    
  def load_file(fname)
    puts "load_file #{fname}"
    fname = ShaneApp.mkfname(fname)
    data = NSData.dataWithContentsOfFile(fname)
    pp data
    everything = NSRange.new(0, @text.textStorage.length)
    @text.replaceCharactersInRange_withRTF(everything, data)
  end

  def write_file(fname)
    puts "write_file #{fname}"
    fname = ShaneApp.mkfname(fname)
    everything = NSRange.new(0, @text.textStorage.length) 
    data = @text.RTFFromRange(everything)
    pp data.writeToFile_atomically(fname, true)
  end
  
  # GET => Advice to a Young Scientst
  def windowWillClose(notification)
    write_file("test")
    true
  end
  
  def comboBox_objectValueForItemAtIndex(box, index)
    File.basename(ShaneApp.files[index], '.rtf')
  end
  
  def numberOfItemsInComboBox(box)
    ShaneApp.files.size
  end

  def comboBoxSelectionDidChange(note)
    old_fname = note.object.stringValue
    write_file(old_fname)
    
    fname = ShaneApp.files[note.object.indexOfSelectedItem]
    load_file(fname)
    puts @combo.stringValue
  end
  
end
