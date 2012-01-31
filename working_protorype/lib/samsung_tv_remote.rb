require "socket"
require "base64"
require File.dirname(__FILE__) + "/samsung_tv_remote/interactive_mode.rb"

class SamsungTvRemote

  REMOTE_NAME = "Ruby Samsung Remote";

  APPSTRING = "iphone..iapp.samsung"

  KEY_CODES = [ :KEY_0, :KEY_1, :KEY_11, :KEY_12, :KEY_16_9, :KEY_2, :KEY_3,
    :KEY_3SPEED, :KEY_4, :KEY_4_3, :KEY_5, :KEY_6, :KEY_7, :KEY_8, :KEY_9,
    :KEY_AD, :KEY_ADDDEL, :KEY_ALT_MHP, :KEY_ANGLE, :KEY_ANTENA, :KEY_ANYNET,
    :KEY_ANYVIEW, :KEY_APP_LIST, :KEY_ASPECT, :KEY_AUTO_ARC_ANTENNA_AIR,
    :KEY_AUTO_ARC_ANTENNA_CABLE, :KEY_AUTO_ARC_ANTENNA_SATELLITE,
    :KEY_AUTO_ARC_ANYNET_AUTO_START, :KEY_AUTO_ARC_ANYNET_MODE_OK,
    :KEY_AUTO_ARC_AUTOCOLOR_FAIL, :KEY_AUTO_ARC_AUTOCOLOR_SUCCESS,
    :KEY_AUTO_ARC_CAPTION_ENG, :KEY_AUTO_ARC_CAPTION_KOR,
    :KEY_AUTO_ARC_CAPTION_OFF, :KEY_AUTO_ARC_CAPTION_ON,
    :KEY_AUTO_ARC_C_FORCE_AGING, :KEY_AUTO_ARC_JACK_IDENT,
    :KEY_AUTO_ARC_LNA_OFF, :KEY_AUTO_ARC_LNA_ON, :KEY_AUTO_ARC_PIP_CH_CHANGE,
    :KEY_AUTO_ARC_PIP_DOUBLE, :KEY_AUTO_ARC_PIP_LARGE,
    :KEY_AUTO_ARC_PIP_LEFT_BOTTOM, :KEY_AUTO_ARC_PIP_LEFT_TOP,
    :KEY_AUTO_ARC_PIP_RIGHT_BOTTOM, :KEY_AUTO_ARC_PIP_RIGHT_TOP,
    :KEY_AUTO_ARC_PIP_SMALL, :KEY_AUTO_ARC_PIP_SOURCE_CHANGE,
    :KEY_AUTO_ARC_PIP_WIDE, :KEY_AUTO_ARC_RESET, :KEY_AUTO_ARC_USBJACK_INSPECT,
    :KEY_AUTO_FORMAT, :KEY_AUTO_PROGRAM, :KEY_AV1, :KEY_AV2, :KEY_AV3,
    :KEY_BACK_MHP, :KEY_BOOKMARK, :KEY_CALLER_ID, :KEY_CAPTION, :KEY_CATV_MODE,
    :KEY_CHDOWN, :KEY_CHUP, :KEY_CH_LIST, :KEY_CLEAR, :KEY_CLOCK_DISPLAY,
    :KEY_COMPONENT1, :KEY_COMPONENT2, :KEY_CONTENTS, :KEY_CONVERGENCE,
    :KEY_CONVERT_AUDIO_MAINSUB, :KEY_CUSTOM, :KEY_CYAN, :KEY_DEVICE_CONNECT,
    :KEY_DISC_MENU, :KEY_DMA, :KEY_DNET, :KEY_DNIe, :KEY_DNSe, :KEY_DOOR,
    :KEY_DOWN, :KEY_DSS_MODE, :KEY_DTV, :KEY_DTV_LINK, :KEY_DTV_SIGNAL,
    :KEY_DVD_MODE, :KEY_DVI, :KEY_DVR, :KEY_DVR_MENU, :KEY_DYNAMIC, :KEY_ENTER,
    :KEY_ENTERTAINMENT, :KEY_ESAVING, :KEY_EXIT, :KEY_EXT1, :KEY_EXT10,
    :KEY_EXT11, :KEY_EXT12, :KEY_EXT13, :KEY_EXT14, :KEY_EXT15, :KEY_EXT16,
    :KEY_EXT17, :KEY_EXT18, :KEY_EXT19, :KEY_EXT2, :KEY_EXT20, :KEY_EXT21,
    :KEY_EXT22, :KEY_EXT23, :KEY_EXT24, :KEY_EXT25, :KEY_EXT26, :KEY_EXT27,
    :KEY_EXT28, :KEY_EXT29, :KEY_EXT3, :KEY_EXT30, :KEY_EXT31, :KEY_EXT32,
    :KEY_EXT33, :KEY_EXT34, :KEY_EXT35, :KEY_EXT36, :KEY_EXT37, :KEY_EXT38,
    :KEY_EXT39, :KEY_EXT4, :KEY_EXT40, :KEY_EXT41, :KEY_EXT5, :KEY_EXT6,
    :KEY_EXT7, :KEY_EXT8, :KEY_EXT9, :KEY_FACTORY, :KEY_FAVCH, :KEY_FF,
    :KEY_FF_, :KEY_FM_RADIO, :KEY_GAME, :KEY_GREEN, :KEY_GUIDE, :KEY_HDMI,
    :KEY_HDMI1, :KEY_HDMI2, :KEY_HDMI3, :KEY_HDMI4, :KEY_HELP, :KEY_HOME,
    :KEY_ID_INPUT, :KEY_ID_SETUP, :KEY_INFO, :KEY_INSTANT_REPLAY, :KEY_LEFT,
    :KEY_LINK, :KEY_LIVE, :KEY_MAGIC_BRIGHT, :KEY_MAGIC_CHANNEL, :KEY_MDC,
    :KEY_MENU, :KEY_MIC, :KEY_MORE, :KEY_MOVIE1, :KEY_MS, :KEY_MTS, :KEY_MUTE,
    :KEY_NINE_SEPERATE, :KEY_OPEN, :KEY_PANNEL_CHDOWN, :KEY_PANNEL_CHUP,
    :KEY_PANNEL_ENTER, :KEY_PANNEL_MENU, :KEY_PANNEL_POWER, :KEY_PANNEL_SOURCE,
    :KEY_PANNEL_VOLDOW, :KEY_PANNEL_VOLUP, :KEY_PANORAMA, :KEY_PAUSE,
    :KEY_PCMODE, :KEY_PERPECT_FOCUS, :KEY_PICTURE_SIZE, :KEY_PIP_CHDOWN,
    :KEY_PIP_CHUP, :KEY_PIP_ONOFF, :KEY_PIP_SCAN, :KEY_PIP_SIZE, :KEY_PIP_SWAP,
    :KEY_PLAY, :KEY_PLUS100, :KEY_PMODE, :KEY_POWER, :KEY_POWEROFF,
    :KEY_POWERON, :KEY_PRECH, :KEY_PRINT, :KEY_PROGRAM, :KEY_QUICK_REPLAY,
    :KEY_REC, :KEY_RED, :KEY_REPEAT, :KEY_RESERVED1, :KEY_RETURN, :KEY_REWIND,
    :KEY_REWIND_, :KEY_RIGHT, :KEY_RSS, :KEY_RSURF, :KEY_SCALE, :KEY_SEFFECT,
    :KEY_SETUP_CLOCK_TIMER, :KEY_SLEEP, :KEY_SOURCE, :KEY_SRS, :KEY_STANDARD,
    :KEY_STB_MODE, :KEY_STILL_PICTURE, :KEY_STOP, :KEY_SUB_TITLE, :KEY_SVIDEO1,
    :KEY_SVIDEO2, :KEY_SVIDEO3, :KEY_TOOLS, :KEY_TOPMENU, :KEY_TTX_MIX,
    :KEY_TTX_SUBFACE, :KEY_TURBO, :KEY_TV, :KEY_TV_MODE, :KEY_UP, :KEY_VCHIP,
    :KEY_VCR_MODE, :KEY_VOLDOWN, :KEY_VOLUP, :KEY_WHEEL_LEFT, :KEY_WHEEL_RIGHT,
    :KEY_W_LINK, :KEY_YELLOW, :KEY_ZOOM1, :KEY_ZOOM2, :KEY_ZOOM_IN,
    :KEY_ZOOM_MOVE, :KEY_ZOOM_OUT]

  KEY_CODES.each { |k| define_method(k.downcase) { control(k) } }

  attr_accessor :tv_ip, :tv_model

  # Doesn't seem to be really used
  attr_accessor :my_ip

  # Used for the access control/validation, but not after that AFAIK
  attr_accessor :my_mac

  def self.interactive!(*args)
    InteractiveMode.start! new(*args)
  end

  def initialize(tv_ip, tv_model, my_mac)
    @tv_ip        = tv_ip
    @tv_appstring = "iphone.#{tv_model}.iapp.samsung"
    @my_ip        = local_ip
    @my_mac       = my_mac
  end


  def control(key_code)
    Socket.tcp(@tv_ip, 55000) do |sock|
      sock.print part_1
      sock.print part_2
      sock.print part_3(key_code)
      sock.close_write
    end
  end

  private

  def local_ip
    @orig_sock, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = @orig_sock
  end

  def msg_value(value)
    value.length.chr << 0x00.chr << value
  end

  def part_1
    0x00.chr <<
    msg_value(APPSTRING) <<
    msg_value(part_1_data)
  end

  def part_1_data
    0x64.chr << 0x00.chr <<
    msg_value(Base64.encode64(my_ip).chop) <<
    msg_value(Base64.encode64(my_mac).chop) <<
    msg_value(Base64.encode64(REMOTE_NAME).chop)
  end

  def part_2
    0x00.chr <<
    msg_value(APPSTRING) <<
    msg_value(0xc8.chr << 0x00.chr)
  end

  def part_3(key_code)
    0x00.chr <<
    msg_value(@tv_appstring) <<
    msg_value(part_3_data(key_code))
  end

  def part_3_data(key_code)
    0x00.chr << 0x00.chr << 0x00.chr <<
    msg_value(Base64.encode64(key_code.to_s).chop)
  end
end
