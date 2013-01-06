module HeadshotSupport
  def headshot_file_path
    file_name = "headshot_capture_#{rand(10000)}_#{Time.now.to_i}.jpg"
    File.join(Rails.root, 'public', 'headshots', file_name)
  end

  def headshot_image_url(photo)
    'http://' + request.host_with_port + '/headshots/' + photo.image_file_name
  end
end
