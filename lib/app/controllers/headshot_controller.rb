class HeadshotController < ApplicationController
  include HeadshotSupport
  def capture
    session[:user] ||= "User #{Time.now.to_i}"
    logger.info "User captured #{session[:user]}"

    file_path =  headshot_file_path

    if request.raw_post
      File.open(file_path, 'wb') do |f|
        f.write request.raw_post
      end
    end

    @headshot_photo = HeadshotPhoto.new
    @headshot_photo.image = File.new(file_path)
    @headshot_photo.save

    render :text => "#{headshot_image_url(@headshot_photo)}"
  end
end
