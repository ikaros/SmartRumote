class Mapping

  KEY_CODES = {
    :up        => :"\e[A",
    :down      => :"\e[B",
    :left      => :"\e[D",
    :right     => :"\e[C",
    :backspace => :"\x7F",
    :enter     => :"\r"
  }

  def initialize(&block)
    @mapping = {}
    block && block.call(self)
  end

  def map(key_code, tv_key=nil, &block)
    @mapping[key_code] = block || tv_key
  end

  def action(key_code)
    @mapping[key_for(key_code)]
  end

  def to_s
    result = ""
    @mapping.to_a.map { |k,v|
      v = "SCRIPT" if v.instance_of? Proc
      "#{k} : #{v}".ljust(15)
    }.each_slice(3) { |s|
      result << s.join("\t\t") << "\n"
    }
    result
  end

  private

  def key_for(key_code)
    KEY_CODES[key_code] || key_code.to_sym
  end

  def tv_key_for(key)
    "key_#{key}"
  end
end

map = Mapping.new do |m|
  m.map(:q) { |r| exit }
  m.map :m,         :mute
  m.map :up,        :up
  m.map :down,      :down
  m.map :left,      :left
  m.map :right,     :right
  m.map :enter,     :enter
  m.map :e,         :exit
  m.map :backspace, :return
  m.map :i,         :info
  m.map :d,         :rewind
  m.map :f,         :ff
  m.map :p,         :poweroff
  m.map :j,         :chup
  m.map :k,         :chdown
  m.map :t,         :picture_size
  m.map :o,         :volup
  m.map :l,         :voldown
  m.map :num_0,     :num_0
  m.map :num_1,     :num_1
  m.map :num_2,     :num_2
  m.map :num_3,     :num_3
  m.map :num_4,     :num_4
  m.map :num_5,     :num_5
  m.map :num_6,     :num_6
  m.map :num_7,     :num_7
  m.map :num_8,     :num_8
  m.map :num_9,     :num_9
end
puts map.to_s
