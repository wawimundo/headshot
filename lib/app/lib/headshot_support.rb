module HeadshotSupport
  def headshot_file_path
    file_name = "headshot_capture_#{headshot_file_timestamp}.jpg"
    File.join(Rails.root, 'public', 'headshots', file_name)
  end

  def headshot_image_url(file_name)
    'http://' + request.host_with_port + '/headshots/' + file_name
  end

  def headshot_save_image(file_path, raw_jpeg_data)
    if raw_jpeg_data
      begin
        File.open(file_path, 'wb') do |file|
          file.write raw_jpeg_data
        end
      rescue
        raise "Headshot: cannot save headshot on #{file_path}. Please check file permissions."
      end
    else
      return nil
    end

    true
  end

  def headshot_file_timestamp
    "#{rand(10000)}_#{Time.now.to_i}"
  end
end
