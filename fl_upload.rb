require 'flickraw'

API_KEY='YOURS_HERE'
SHARED_SECRET='YOURS_HERE'
ACCESS_TOKEN='YOURS_HERE'
ACCESS_SECRET='YOURS_HERE'


FlickRaw.api_key = API_KEY
FlickRaw.shared_secret = SHARED_SECRET
flickr.access_token = ACCESS_TOKEN
flickr.access_secret = ACCESS_SECRET

folders = Array.new()
pictures = Array.new()
pic_ids = Array.new() 

def acceptable_file (file_name)
   # basic weeding out of files that are not acceptable to Flickr
   accepted_formats = [".jpg", ".png",".mov", ".avi"]
   return accepted_formats.include? File.extname(file_name.downcase)

end

starting_folder = Dir.pwd
current_folder = starting_folder
Dir.foreach(current_folder) {|x| folders << x if Dir.exists?(x)}  #put all folders in an array
puts folders
folders.each {|x|                               #now loop through each folder and ...
   next if (x == "." || x == "..")
   current_folder = starting_folder+"/"+x       
   Dir.chdir(current_folder)			# go into the folder
   puts "now in #{current_folder}"
   pictures.clear    				#empty the array that contains the pictures
   pic_ids.clear				#empty the array that contains the pic codes
   Dir.foreach(current_folder) { |y|            # for each file in the folder    
      pictures << y if (y !=".." && y !=".")     # add picture name to the array
   }
   puts "found these pictures #{pictures}" 
   pictures.each { |pic|                           #now for each picture in the array upload it to flickr and capture its id
      begin
         puts "attempting to upload #{pic}"
         if acceptable_file(pic) then
            result = flickr.upload_photo pic, :title => pic, :is_public => 0, :is_friend => 0, :is_family => 0
            pic_ids << result
            puts "succesfully uploaded #{pic}"
            puts "now deleting #{pic}"
            File.delete(pic)
         else
            puts "#{pic} is not an acceptable format.. ignoring"
         end   
      rescue
         puts "an error while trying to upload #{pic} from folder #{x}.. trying to continue"
	 puts $!, $@
         next
      end
   }
 
   if !pic_ids.empty? then   #there are pics in the array
          # now have done all the files in the folder, so add them to a set 
          # first check to see if the photoset exists already
          #and if set exists use that one for the pics, otherwise create a new one
       existing_photosets = flickr.photosets.getList   #get photoset  list
       set_exists=false
       photoset_id =0 
       existing_photosets.each {|set|
         if set.title == x then    # try to find a set with the same name as the folder
            set_exists = true 
            photoset_id= set.id
            puts "found existing set #{x} with id #{photoset_id}"
         end
      }
      if not set_exists then
         photoset = flickr.photosets.create :title => set_name, :primary_photo_id => pic_ids[0] 
         photoset_id = photoset.id
         puts "created new photoset called #{x} with id #{photoset_id}"
      end
      #now assign photos to the photoset (existing or new) 
      pic_ids.each { |code|
         begin 
            next if code == 0   #invalid filetypes return 0, which gets added to the array.  so ignore
            flickr.photosets.addPhoto :photoset_id => photoset_id, :photo_id => code     #add each picture to the photoset
            puts "adding photo to photoset #{x}"
         rescue
            puts "an error here while trying to add #{code} to #{photoset.id} .. trying to continue"
	    puts $!, $@
            next
         end
      }
   end
}
