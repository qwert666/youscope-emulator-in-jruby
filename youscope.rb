require 'java'
require 'ruby-processing'

class Array   
     def split
         num = self.length/2
         tab = []
         for row in 0..1
             tab[row] = self[2*row...2*(row+1)]
         end
          tab
      end 
end 

class Youscope < Processing::App

import javax.sound.sampled.AudioSystem
import javax.sound.sampled.AudioFormat

file = java.io.File.new('scope.wav')
@@stream = AudioSystem.getAudioInputStream(file)
info = @@stream.getFormat
@@read_length = info.getFrameRate/24
 
	def setup
	end

	def linie
		stroke 40,40,0
		10.times do |x|
			line x*width/10,0,x*width/10,width
			@a = x != 4 ? (stroke_weight 1) : (stroke_weight 3)
		end

		8.times do |y|
			line 0,y*height/8,width,y*height/8
			@b = y != 3 ? (stroke_weight 1) : (stroke_weight 3)
		end

		100.times do |x|
			line x*width/100,height/2-3, x*width/100,height/2+3
		end

		80.times do |y|
			line width/2-3, y*height/80, width/2+3, y*height/80
		end
	end

	def draw
    	  background 0,0,0,128
	  linie
	  @@buffer = Array.new(@@read_length).to_java(:byte)
	  @@stream.read(@@buffer) 
	    (0..1999).step(4) do |i|
              r = @@buffer[i..i+4].to_a.split.collect{|x| x.reverse}.flatten.pack('C*').unpack('s*')
              x = r[1]*960/65536 + 960/2
              y = -r[0]*720/65536 + 720/2
      	      point x,y
	      stroke 0,255,0
	    end
	end
end

Youscope.new(:width => 960, :height =>720, :title => "youscope", :full_screen => false)
