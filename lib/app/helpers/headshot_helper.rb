module HeadshotHelper
  def headshot_snap_button(label = 'Snap', options = {})
    options.reverse_merge!({
      :onclick => 'headshotHandlers.snap()'
    })

    button_tag(label, options)
  end

  def headshot_config_button(label = 'Configure', options = {})
    options.reverse_merge!({
      :onclick => 'headshot.configure()'
    })

    button_tag(label, options)
  end

  def headshot_camera(width = 400, height = 300)
    raw(%{
    <script language="JavaScript">
      headshotInitializer.setup(#{width}, #{height}, params);
    </script>
    })
  end

  def headshot_default_config(session_key, capture_path, options = {})
    options.reverse_merge!(headshot_default_options)
    session_value = u(cookies[session_key])
    raw(%{
    <script language="JavaScript">
        var params = {
            session_key_name: encodeURIComponent('#{session_value}'),
            csrf_token: encodeURI(encodeURI(headshotUtils.getPageMetaValue('csrf-token')))
        };

        var headshotHandlers = {
            onComplete: function(msg) {
                headshot.reset();
            },
            snap: function() {
                headshot.snap();
            }
        }

        headshot.set_swf_url('#{options[:swf_url]}')
        headshot.set_api_url('#{capture_path}');
        headshot.set_quality(#{options[:quality]});
        headshot.set_shutter_sound(#{options[:shutter_sound]}, '#{options[:shutter_sound_url]}');
        headshot.set_hook('onComplete', '#{options[:on_complete]}');
    </script>
    })
  end

  def headshot_default_options
    {
        :swf_url => '/swfs/headshot.swf',
        :quality => 90,
        :shutter_sound => true,
        :shutter_sound_url => '/audio/shutter.mp3',
        :on_complete => 'headshotHandlers.onComplete'
    }
  end
end
