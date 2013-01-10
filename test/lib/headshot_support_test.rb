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
    @temp_data_path = "#{Rails.root}/tmp/#{@file_name}"
  end

  def test_default_settings
    @support_class.stubs(:headshot_file_timestamp).returns(@timestamp)
    @support_class.stubs(:request).returns(stub(:host_with_port => @sample_host))

    assert_equal("#{Rails.root}/public/headshots/headshot_capture_#{@timestamp}.jpg", @support_class.headshot_file_path)
    assert_equal("http://#{@sample_host}/headshots/#{@file_name}", @support_class.headshot_image_url(@file_name))
  end

  def test_saving_of_image
    assert_equal(@support_class.headshot_save_image(@temp_data_path, "some data"), true)
    assert_nil(@support_class.headshot_save_image(@temp_data_path, nil))

    File.stubs(:open).raises(IOError)
    exception = assert_raise(RuntimeError) {
      @support_class.headshot_save_image("whatever.jpg", "data")
    }
    assert_equal(exception.message, "Headshot: cannot save headshot on whatever.jpg. Please check file permissions.")
  end
end