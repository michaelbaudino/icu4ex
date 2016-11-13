defmodule ICUTest.NumberFormat do
  use ExUnit.Case
  doctest ICU.NumberFormat

  import ICU.NumberFormat

  test "add a separator every 3 digits" do
    assert format("1234567890") == "1,234,567,890"
  end

  test "use a localized separator" do
    assert format("1234567890", :fr) == "1.234.567.890"
  end

  test "support `number` input as Integer" do
    assert format(1234567890) == "1,234,567,890"
  end

  test "format percentages" do
    assert format_percent(50) == "50%"
  end
end
