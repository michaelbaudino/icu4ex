defmodule ICUTest.TimeFormat do
  use ExUnit.Case
  doctest ICU.TimeFormat

  import ICU.TimeFormat
  alias ICU.LocaleNotFound
  alias ICU.FormatNotFound

  setup do
    {:ok, time} = Time.new(12, 15, 00)
    {:ok, time: time}
  end

  test "raise an error when `locale` is not supported", %{time: time} do
    assert_raise LocaleNotFound, fn ->
      format(time, :unsupported_locale)
    end
  end

  test "raise an error when `format` is not supported", %{time: time} do
    assert_raise FormatNotFound, fn ->
      format(time, :en, "unsupported_format")
    end
  end

  test "convert a time to a string in `short` format", %{time: time} do
    assert format(time, :en, "short") == "1984-04-26"
  end

  test "convert a time to a string in `medium` format", %{time: time} do
    assert format(time, :en, "medium") == "Apr. 26, 1984"
  end

  test "convert a time to a string in `long` format", %{time: time} do
    assert format(time, :en, "long") == "April 26, 1984"
  end

  test "convert a time to a string in `full` format", %{time: time} do
    assert format(time, :en, "full") == "Thursday, April 26, 1984"
  end

  test "default to `medium` format", %{time: time} do
    assert format(time, :en) == format(time, :en, "medium")
  end

  test "support `short` format in locale :fr", %{time: time} do
    assert format(time, :fr, "short") == "26/04/1984"
  end

  test "support `medium` format in locale :fr", %{time: time} do
    assert format(time, :fr, "medium") == "26 avr. 1984"
  end

  test "support `long` format in locale :fr", %{time: time} do
    assert format(time, :fr, "long") == "26 avril 1984"
  end

  test "support `full` format in locale :fr", %{time: time} do
    assert format(time, :fr, "full") == "jeudi 26 avril 1984"
  end
end
