defmodule ICUTest.TimeFormat do
  use ExUnit.Case
  doctest ICU.TimeFormat

  import ICU.TimeFormat
  alias ICU.LocaleNotFound
  alias ICU.FormatNotFound

  setup do
    {:ok, time} = Time.new(15, 45, 60)
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
    assert format(time, :en, "short") == "3:45pm"
  end

  test "convert a time to a string in `medium` format", %{time: time} do
    assert format(time, :en, "medium") == "15:45"
  end

  test "convert a time to a string in `long` format", %{time: time} do
    assert format(time, :en, "long") == "15:45:60"
  end

  test "convert a time to a string in `full` format", %{time: time} do
    assert format(time, :en, "full") == "15:45:60"
  end

  test "default to `medium` format", %{time: time} do
    assert format(time, :en) == format(time, :en, "medium")
  end

  test "support `short` format in locale :fr", %{time: time} do
    assert format(time, :fr, "short") == "15h45"
  end

  test "support `medium` format in locale :fr", %{time: time} do
    assert format(time, :fr, "medium") == "15h 45m 60s"
  end

  test "support `long` format in locale :fr", %{time: time} do
    assert format(time, :fr, "long") == "15h 45min 60s"
  end

  test "support `full` format in locale :fr", %{time: time} do
    assert format(time, :fr, "full") == "15h 45min 60s"
  end
end
