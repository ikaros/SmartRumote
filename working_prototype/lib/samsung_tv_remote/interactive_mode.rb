class SamsungTvRemote
  class InteractiveMode
    DEFAULT_MAPPING = {
      "q"    => ->(r) { exit },
      "m"    => ->(r) { r.key_mute },
      "\e[A" => ->(r) { r.key_up },
      "\e[B" => ->(r) { r.key_down },
      "\e[D" => ->(r) { r.key_left },
      "\e[C" => ->(r) { r.key_right },
      "\r"   => ->(r) { r.key_enter },
      "e"    => ->(r) { r.key_exit },
      "\x7F" => ->(r) { r.key_return },
      "i"    => ->(r) { r.key_info },
      "d"    => ->(r) { r.key_rewind },
      "f"    => ->(r) { r.key_ff },
      "p"    => ->(r) { r.key_poweroff },
      "j"    => ->(r) { r.key_chup },
      "k"    => ->(r) { r.key_chdown },
      "t"    => ->(r) { r.key_picture_size },
      "o"    => ->(r) { r.key_volup },
      "l"    => ->(r) { r.key_voldown },
      "0"    => ->(r) { r.key_0 },
      "1"    => ->(r) { r.key_1 },
      "2"    => ->(r) { r.key_2 },
      "3"    => ->(r) { r.key_3 },
      "4"    => ->(r) { r.key_4 },
      "5"    => ->(r) { r.key_5 },
      "6"    => ->(r) { r.key_6 },
      "7"    => ->(r) { r.key_7 },
      "8"    => ->(r) { r.key_8 },
      "9"    => ->(r) { r.key_9 }
    }

    attr_accessor :mapping

    def initialize(remote, mapping=DEFAULT_MAPPING)
      @remote  = remote
      @buffer  = ""
      @mapping = mapping
    end

    def self.start!(*args); new(*args).start! end

    def parse_buffer!(buffer=@buffer)
      return false if buffer == ''

      tmp_buffer = buffer.clone

      if action = mapping[tmp_buffer]
        action.call(@remote)
        @buffer.clear
      else
        tmp_buffer[0] = ''
        parse_buffer!(tmp_buffer)
      end
    end

    def start!
      system("stty raw -echo")

      while c = STDIN.getc
        @buffer << c
        parse_buffer!
      end
    ensure
      system("stty -raw echo")
    end
  end
end
