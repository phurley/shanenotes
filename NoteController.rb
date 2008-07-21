#
#  NoteController.rb
#  ShaneNotes
#
#  Created by Patrick Hurley on 7/19/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'
require 'pp'
require 'time'

require 'ShaneApp.rb'


# Actions:
#  1. Load Page from combo box (file must exist)
#  2. Click WikiLink ->
#     a. Page exists (change combo box and load page)
#     b. New Page (create template file, rescan files for combo box, do above)

class NoteController < OSX::NSObject
  include OSX
  ib_outlet :text
  ib_outlet :combo
  ib_action :test
  
  def textView_clickedOnLink_atIndex(tv, link, index)    
    files = ShaneApp.files.map { |f| File.basename(f,'.rtf') }
    unless index = files.index(link)
      data = NSText.new
      data.string = "Shane Note create #{Time.now.to_s}"
      fname = ShaneApp.mkfname(link)
      puts "Writing #{data.string} to #{fname}"
      
      everything = NSRange.new(0, data.textStorage.length) 
      data = data.RTFFromRange(everything)
      data.writeToFile_atomically(fname, false)
      ShaneApp.rescan
      files = ShaneApp.files.map { |f| File.basename(f,'.rtf') }
      index = files.index(link)
    end
    
    # load_file(link)
    if index
      @combo.selectItemAtIndex(index)
    end
    
    true
  end
  
  def test
    update_links
  end
  
  def update_links
    data = @text.textStorage
    everything = NSRange.new(0, data.length)
    data.removeAttribute_range(NSLinkAttributeName, everything)
    
    data.string.to_s.scan(/([A-Z][a-z0-9]+[A-Z][A-Za-z0-9]+)/) do |match|
      start,stop = *$~.offset(1)
      length = stop - start
      range = NSRange.new(start, length)
      data.addAttribute_value_range(NSLinkAttributeName, match.first, range)
    end
  end
  
  def awakeFromNib
    load_file("test")
  end
    
  def load_file(fname)
    puts "load_file #{fname}"
    fname = ShaneApp.mkfname(fname)
    data = NSData.dataWithContentsOfFile(fname)
    
    everything = NSRange.new(0, @text.textStorage.length)
    @text.replaceCharactersInRange_withRTF(everything, data)
    update_links
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
    write_file(old_fname) unless old_fname.empty?
    
    fname = ShaneApp.files[note.object.indexOfSelectedItem]
    load_file(fname)
    puts @combo.stringValue
  end

  
  def textDidChange(notification)
    update_links
  end
  
end
