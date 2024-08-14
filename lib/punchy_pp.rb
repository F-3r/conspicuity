# frozen_string_literal: true

require "pp"
require_relative "railtie" if defined?(Rails::Railtie)

module PunchyPP
  LINE_CONTINUATIION = "\e[94m···\e[0m  "
  PATTERNS = {
    white: "\e[30m\e[107m%s\e[0m",
    green: "\e[30m\e[102m%s\e[0m",
    magenta: "\e[97m\e[105m%s\e[0m",
    yellow: "\e[30m\e[103m%s\e[0m",
    blue: "\e[97m\e[104m%s\e[0m",
    purple: "\e[97m\e[45m%s\e[0m",
    cyan: "\e[30m\e[106m%s\e[0m",
    red: "\e[97m\e[101m%s\e[0m"
  }

  PATTERNS.each do |color, pattern|
    define_method color do |text|
      pattern % text
    end
  end

  COLOR_CYCLE = PATTERNS.keys.cycle

  def cycle_color
    @current_color = config[:color] || COLOR_CYCLE.next
  end

  def current_color
    @current_color || cycle_color
  end

  def config
    @config ||= {out: $stdout}
  end

  def config=(options)
    @config = options
  end

  def paint(text)
    send current_color, text
  end

  def border(text = nil)
    paint "  #{text.to_s.ljust(100)}"
  end

  def line(text = nil)
    paint(" ") << "  %s" % text.to_s
  end

  def wrap_text(text, width = 80)
    return text if text.size <= width

    lines = []
    current_line = ""

    text.split(/\s/).each do |word|
      if (current_line.size + word.size + 1) > width
        lines << current_line
        current_line = word
      else
        current_line += (current_line.empty? ? "" : " ") + word
      end
    end
    lines << current_line unless current_line.empty?

    lines[1..-1].each { |it| it.prepend LINE_CONTINUATIION } # standard:disable Style/SlicingWithRange
    lines
  end

  def out(text)
    PunchyPP.config[:out].puts text
  end

  def interesting_caller(callers)
    callers.reject { |it| it.match __FILE__ }
  end

  def puts(*objects)
    PunchyPP.cycle_color

    title = caller(1..1).first.to_s
    lines = objects
      .map { |it| it.pretty_inspect }
      .flat_map { |it| wrap_text it }

    out border(title)
    out line
    out lines.map { |it| line it }
    out line
    out border " "
  end

  module Methods
    def ppp(*objects)
      PunchyPP.puts(*objects)
    end
  end

  extend self
end
