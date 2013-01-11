require "test_helper"

class HeadshotControllerTest < ActionController::TestCase
  def setup
    # Do nothing
  end

  def teardown
    # Do nothing
  end

  def test_capture_default_behavior
    post :capture

    assert_response :success

    response_json = JSON.parse(response.body)
    file_name = File.basename(response_json["url"])
    headshot_file_path = File.join(File.dirname(@controller.headshot_file_path), file_name)

    assert_equal('Success', response_json["status"])
    assert_equal('Headshot saved.', response_json["message"])
    assert_equal(true, File.exists?(headshot_file_path))
  end

  def test_capture_saving_error
    @controller.stubs(:headshot_save_image).returns(nil)
    post :capture

    assert_response :success

    response_json = JSON.parse(response.body)

    assert_equal('Error', response_json["status"])
    assert_equal('Saving of headshot failed.', response_json["message"])
  end
end