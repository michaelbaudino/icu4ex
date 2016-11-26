defmodule ICUTest.DateFormat do
  use ExUnit.Case
  doctest ICU.DateFormat

  import ICU.DateFormat
  alias ICU.LocaleNotFound
  alias ICU.FormatNotFound

  setup do
    {:ok, date} = Date.new(1984, 04, 26)
    {:ok, date: date}
  end

  test "raise an error when `locale` is not supported", %{date: date} do
    assert_raise LocaleNotFound, fn ->
      format(date, :unsupported_locale)
    end
  end

  test "raise an error when `format` is not supported", %{date: date} do
    assert_raise FormatNotFound, fn ->
      format(date, :en, "unsupported_format")
    end
  end

  test "convert a date to a string in `short` format", %{date: date} do
    assert format(date, :en, "short") == "1984-04-26"
  end

  test "convert a date to a string in `medium` format", %{date: date} do
    assert format(date, :en, "medium") == "Apr. 26, 1984"
  end

  test "convert a date to a string in `long` format", %{date: date} do
    assert format(date, :en, "long") == "April 26, 1984"
  end

  test "convert a date to a string in `full` format", %{date: date} do
    assert format(date, :en, "full") == "Thursday, April 26, 1984"
  end

  test "default to `medium` format", %{date: date} do
    assert format(date, :en) == format(date, :en, "medium")
  end

  test "support `short` format in locale :fr", %{date: date} do
    assert format(date, :fr, "short") == "26/04/1984"
  end

  test "support `medium` format in locale :fr", %{date: date} do
    assert format(date, :fr, "medium") == "26 avr. 1984"
  end

  test "support `long` format in locale :fr", %{date: date} do
    assert format(date, :fr, "long") == "26 avril 1984"
  end

  test "support `full` format in locale :fr", %{date: date} do
    assert format(date, :fr, "full") == "jeudi 26 avril 1984"
  end
end
