require "find" # to use command-line "find" to go through subdirectories for files
require "open3" # to run ImageMagick's convert from our script
require "fileutils" # file-handling tools

# "strip" is the smaller size, which I always want to be resized to 415 pixels high
# puts Dir.pwd

@quality = "90"
# @size = "PixelsPerInch"
# we will pass the directory to search for images in as an argument

puts "Enter Resolution size ( percent % ): "
@size = gets().chomp()

if @size.to_i.to_s == @size

  @directory = Dir.pwd #store current/working directory

  @resize_dir = "#{@directory}/resized"

  #creates resized folder
  unless File.directory? @resize_dir
    puts "Creating folder #{@resize_dir}/"
    Dir.mkdir @resize_dir
  end

  @strip_dimension = "#{@size.to_i}%"

#method for resizing image
  def resize_image(file)
    puts "Resizing image: #{file}"
    @image = "\"#{file}\""
    @cmd = "convert #{@image} -resize #{@strip_dimension} -quality 90 #{@image}" # the first ImageMagick call I need, to make the "strip" size of the image
    stdin, stdout, stderr = Open3.popen3(@cmd)
    puts l while l = stdout.gets # output any debug stuff from the call to 'convert'
    puts l while l = stderr.gets # output any debug stuff from the call to 'convert'
  end

#SECTION BACKUP
  accepted_formats = [".png", ".jpg"]
  Dir.glob("*").select { |f|
    if File.directory? f
      if f.eql?("resized")
        # puts f
      else
        puts "############ Creating backup folder of #{f}"
        FileUtils.cp_r f, @resize_dir #creates backup folder
      end

    elsif accepted_formats.include?(File.extname(f))
      puts "############ Creating backup picture of #{f}"
      FileUtils.cp_r f, @resize_dir #creates backup unless it satisfy the accepted_formats
    end

  }

  @image_files = File.join("#{@directory}/resized", "**/*.{jpg,png}")


  files = Dir.glob(@image_files) #retrieve all pictures in the directory.

  puts "--------------Resizing #{files.size} images...--------------"

  files.each do |file|
    # puts "Resizing #{file}"
    #puts file
    resize_image(file)

  end

  puts "--------------Finished resizing #{files.size} images--------------"


else
  puts "That is not an integer."
end

