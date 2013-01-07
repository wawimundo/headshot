module HeadshotSupport
  def headshot_file_path
    file_name = "headshot_capture_#{rand(10000)}_#{Time.now.to_i}.jpg"
    File.join(Rails.root, 'public', 'headshots', file_name)
  end

  def headshot_image_url(file_name)
    'http://' + request.host_with_port + '/headshots/' + file_name
  end

  def headshot_save_image(file_path, raw_jpeg_data)
    if raw_jpeg_data
      begin
        File.open(file_path, 'wb') do |file|
          file.write request.raw_post
        end
      rescue
        raise "Headshot: cannot save headshot on #{raw_jpeg_data}. Please check file permissions."
      end
    else
      return nil
    end

    true
  end
end
