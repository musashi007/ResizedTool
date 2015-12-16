require "find" # to use command-line "find" to go through subdirectories for files
require "open3" # to run ImageMagick's convert from our script
require "fileutils" # file-handling tools

# "strip" is the smaller size, which I always want to be resized to 415 pixels high
# puts Dir.pwd


# @size = "PixelsPerInch"
# we will pass the directory to search for images in as an argument

puts "Enter Resolution size ( percent % ): "
@size = gets().chomp()


if @size.to_i.to_s == @size

  @directory = Dir.pwd #store current/working directory


  @strip_dimension = "#{@size.to_i}%"

  #method for copying images
  def copy_images_to_image_folder(images)
    files = Dir.glob(images) #retrieve all pictures in the directory.
    if files.size > 0
      puts "--------------Copying #{files.size} images...--------------"
      files.each do |file|
        # puts file
        puts "############## Copying #{File.basename(file)} ############## "
        # puts "Copying ############## #{File.basename(file)} to destination folder ############## #{@original_images}"
        FileUtils.cp_r "#{file}", @images_at_image_folder #creates backup unless it satisfy the accepted_formats
        # FileUtils.rm(file)
      end
      puts "--------------Finished copying #{files.size} images--------------"
    end
  end

  #method for copying images
  def copy_images(images)
    files = Dir.glob(images) #retrieve all pictures in the directory.
    if files.size > 0
      puts "--------------Copying #{files.size} images...--------------"
      files.each do |file|
        # puts file
        puts "############## Copying #{File.basename(file)} ############## "
        # puts "Copying ############## #{File.basename(file)} to destination folder ############## #{@original_images}"
        FileUtils.cp_r "#{file}", @original_images #creates backup unless it satisfy the accepted_formats
        # FileUtils.rm(file)
      end
      puts "--------------Finished copying #{files.size} images--------------"
    end
  end

  def delete_all_pictures(pictures)
    files = Dir.glob(pictures) #retrieve all pictures in the directory.
    if files.size > 0
      puts "--------------Deleting #{files.size} images...--------------"
      files.each do |file|
        # puts file
        puts "############## Deleting #{File.basename(file)} ############## "
        # puts "Copying ############## #{File.basename(file)} to destination folder ############## #{@original_images}"
        FileUtils.rm(file)
      end
      puts "--------------Finished Deleting #{files.size} images--------------"
    end
  end


  def get_resize_images(resize)
    files = Dir.glob(resize) #retrieve all pictures in the directory.
    if files.size > 0
      puts "--------------Resizing #{files.size} images at #{resize}--------------"
      files.each do |file|
        # puts "Resizing #{file}"
        # puts file
        resize_image(file)
      end
      puts "--------------Finished resizing #{files.size} images--------------"
    end
  end


  #method for resizing image
  def resize_image(file)
    puts "Resizing image: #{file}"
    @image = "\"#{file}\""
    @cmd = "convert #{@image} -resize #{@strip_dimension} -quality 90 #{@image}" # the first ImageMagick call I need, to make the "strip" size of the image
    stdin, stdout, stderr = Open3.popen3(@cmd)
    puts l while l = stdout.gets # output any debug stuff from the call to 'convert'
    puts l while l = stderr.gets # output any debug stuff from the call to 'convert'
  end

  Dir.glob("**/").select { |f|
    if File.directory? f
      if f.include?("image")
        @parent = File.dirname(f)
        @original_images = "#{@parent}/image_original"
        if !f.include?("image_original")
          # @image_folder = f
          # puts "#{f}"
          # puts "Creating image_original folder at #{@parent}"
          FileUtils.mkdir_p @original_images
        end
      end
    end
  }


  #SECTION BACKUP
  accepted_formats = [".png", ".jpg"]
  Dir.glob("**/").select { |f|
    if File.directory? f
      if f.include?("image")
        @parent = File.dirname(f)
        @original_images = "#{@parent}/image_original"
        @images_at_image_folder = "#{@parent}/image"
        # puts "#{@parent}"


        if !f.include?("image_original")
          @image_folder = f
          # puts "#{f}"
          # puts "Creating image_original folder at #{@parent}"
          # FileUtils.mkdir_p @original_images
        end

        if f.include?("image_original")
          # puts "#{folder}"
          @folder_image_original = f
          if Dir["#{@folder_image_original}/*.{jpg,png}"].empty?
            @image_files = File.join("#{@image_folder}", "**/*.{jpg,png}")
            copy_images(@image_files)

            @images_of_image_folder = File.join("#{@image_folder}", "**/*.{jpg,png}")
            get_resize_images(@images_of_image_folder)
          else
            puts "Not empty #{@folder_image_original}"
            @image_file = File.join("#{@image_folder}", "**/*.{jpg,png}")
            delete_all_pictures(@image_file)

            @images_of_original_folder = File.join("#{f}", "**/*.{jpg,png}")
            copy_images_to_image_folder(@images_of_original_folder)

            @images_of_image_folder = File.join("#{@image_folder}", "**/*.{jpg,png}")
            get_resize_images(@images_of_image_folder)
          end
        end

      end

    end
  }

else
  puts "That is not an integer."
end


