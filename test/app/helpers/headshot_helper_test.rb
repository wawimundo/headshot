require "test_helper"

class HeadshotHelperTest < ActionView::TestCase
  def test_headshot_snap_button
    button_code = headshot_snap_button('Shoot')
    assert_equal(button_code.include?("Shoot"), true)
    assert_equal(button_code.include?(%{onclick="headshotHandlers.snap()"}), true)

    button_code = headshot_snap_button('Shoot', :onclick => 'customSnapHandler()')
    assert_equal(button_code.include?(%{onclick="customSnapHandler()"}), true)
  end

  def test_headshot_config_button
    button_code = headshot_config_button('Config')
    assert_equal(button_code.include?("Config"), true)
    assert_equal(button_code.include?(%{onclick="headshot.configure()"}), true)

    button_code = headshot_snap_button('Config', :onclick => 'customConfigHandler()')
    assert_equal(button_code.include?(%{onclick="customConfigHandler()"}), true)
  end

  def test_headshot_camera
    html_code = headshot_camera(600, 400)
    assert_equal(html_code.include?(%{<script language="JavaScript">}), true)
    assert_equal(html_code.include?(%{headshotInitializer.setup(600, 400, params);}), true)
    assert_equal(html_code.include?(%{</script>}), true)

    html_code = headshot_camera
    assert_equal(html_code.include?(%{headshotInitializer.setup(400, 300, params);}), true)
  end

  def test_headshot_default_config
    session_key = "abc123"
    session_value = 'some_session_value_zzbb22'
    route_capture_path = "/headshot/capture"

    stubs(:cookies).returns(session_key => session_value)
    stubs(:u).returns(session_key)

    html_code = headshot_default_config(session_key, route_capture_path)

    assert_equal(html_code.include?(%{<script language="JavaScript">}), true)
    assert_equal(html_code.include?(%{session_key_name: encodeURIComponent('abc123')}), true)
    assert_equal(html_code.include?(%{csrf_token: encodeURI(encodeURI(headshotUtils.getPageMetaValue('csrf-token')))}), true)

    assert_equal(html_code.include?(%{headshot.set_swf_url('/swfs/headshot.swf')}), true)
    assert_equal(html_code.include?(%{headshot.set_api_url('/headshot/capture');}), true)
    assert_equal(html_code.include?(%{headshot.set_quality(90);}), true)
    assert_equal(html_code.include?(%{headshot.set_shutter_sound(true, '/audio/shutter.mp3');}), true)
    assert_equal(html_code.include?(%{headshot.set_hook('onComplete', 'headshotHandlers.onComplete');}), true)

    html_code = headshot_default_config(session_key, route_capture_path, {
      :swf_url => 'http://somecdn.com/headshot.swf',
      :quality => 50,
      :shutter_sound => false,
      :on_complete => 'someCustomCompleteHandler'
    })

    assert_equal(html_code.include?(%{session_key_name: encodeURIComponent('abc123')}), true)
    assert_equal(html_code.include?(%{csrf_token: encodeURI(encodeURI(headshotUtils.getPageMetaValue('csrf-token')))}), true)

    assert_equal(html_code.include?(%{headshot.set_swf_url('http://somecdn.com/headshot.swf')}), true)
    assert_equal(html_code.include?(%{headshot.set_api_url('/headshot/capture');}), true)
    assert_equal(html_code.include?(%{headshot.set_quality(50);}), true)
    assert_equal(html_code.include?(%{headshot.set_shutter_sound(false, '/audio/shutter.mp3');}), true)
    assert_equal(html_code.include?(%{headshot.set_hook('onComplete', 'someCustomCompleteHandler');}), true)
  end
end