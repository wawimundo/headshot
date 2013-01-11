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
end