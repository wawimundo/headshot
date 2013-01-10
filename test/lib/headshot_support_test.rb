require "test_helper"

class SupportClass
  include HeadshotSupport

  def request

  end
end

class HeadshotSupportTest < Test::Unit::TestCase
  def setup
    @support_class = SupportClass.new
    @timestamp = "12345_1357840944"
    @file_name = "headshot_capture_#{@timestamp}.jpg"
    @sample_host = "localhost"
  end

  def test_default_settings
    @support_class.stubs(:headshot_file_timestamp).returns(@timestamp)
    @support_class.stubs(:request).returns(stub(:host_with_port => @sample_host))

    assert_equal("#{Rails.root}/public/headshots/headshot_capture_#{@timestamp}.jpg", @support_class.headshot_file_path)
    assert_equal("http://#{@sample_host}/headshots/#{@file_name}", @support_class.headshot_image_url(@file_name))
  end
end