# frozen_string_literal: true

ENV["ENV"] = "test"

require "test_helper"
require_relative "../lib/punchy_pp"

class TestPunchyPP < Minitest::Test
  def setup
    @out = StringIO.new
    PunchyPP.config = {color: :red, out: @out}
  end

  def test_border_with_no_text_is_all_spaces
    assert PunchyPP.border.include? " " * 102
  end

  def test_border_with_text_is_contains_the_text
    assert PunchyPP.border("conspicuous text").include? "conspicuous text"
  end

  def test_border_wrapped_in_color
    assert_equal "\e[97m\e[101m\e[0m", PunchyPP.border.delete(" ")
  end

  def test_line_with_no_text_is_just_the_vertical_border
    assert_equal "\e[97m\e[101m \e[0m", PunchyPP.line.strip
  end

  def test_line_with_text_ends_with_the_text
    assert_equal "\e[97m\e[101m \e[0m  conspicuous text", PunchyPP.line("conspicuous text")
  end

  def test_line_wrapped_in_color
    assert_equal "\e[97m\e[101m\e[0m", PunchyPP.line.delete(" ")
  end

  def test_punchy_pp_puts_basic_output
    PunchyPP.puts("hola!")

    @out.rewind
    output = @out.read.strip.split("\n")

    assert_match(/(\e\[\d+m){2}.+(\e\[0m)/, output[0])
    assert_match PunchyPP.line(""), output[1]
    assert_equal PunchyPP.line("hola!".inspect), output[2]
    assert_match PunchyPP.line(""), output[3]
    assert_match PunchyPP.border(""), output[4]
  end

  def test_punchy_pp_puts_output_with_line_wrapping
    PunchyPP.puts(
      "Extremely long but very very long line of boring text. " \
      "Reeeeally long but very veeeeeeeery long line of veeeery boring text. " \
      "Reeeeally long but very veeeeeeeery long line of veeeery boring text. " \
      "Reeeeally long but very veeeeeeeery long line of veeeery boring text. " \
      "Reeeeally long but very veeeeeeeery long line of veeeery boring text. " \
      "REALLY"
    )
    @out.rewind
    output = @out.read.strip.split("\n")

    assert output[0] =~ /(\e\[\d+m){2}.+(\e\[0m)/
    assert_match PunchyPP.line(""), output[1]
    assert_equal PunchyPP.line("\"Extremely long but very very long line of boring text. Reeeeally long but very"), output[2]
    assert_equal PunchyPP.line("\e[94m···\e[0m  veeeeeeeery long line of veeeery boring text. Reeeeally long but very"), output[3]
    assert_equal PunchyPP.line("\e[94m···\e[0m  veeeeeeeery long line of veeeery boring text. Reeeeally long but very"), output[4]
    assert_equal PunchyPP.line("\e[94m···\e[0m  veeeeeeeery long line of veeeery boring text. Reeeeally long but very"), output[5]
    assert_equal PunchyPP.line("\e[94m···\e[0m  veeeeeeeery long line of veeeery boring text. REALLY\""), output[6]
    assert_match PunchyPP.line(""), output[7]
    assert_match PunchyPP.border(""), output[8]
  end
end
