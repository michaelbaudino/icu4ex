defmodule ICUTest.MessageFormat do
  use ExUnit.Case
  doctest ICU.MessageFormat

  import ICU.MessageFormat
  alias ICU.MessageFormat.MissingValueError

  test "return the string when there is no variable" do
    assert format("Good morning") == "Good morning"
  end

  test "replace simple variables" do
    assert format("Hi {name}, happy {day_of_week}!", %{name: "Mike", day_of_week: "Monday"}) == "Hi Mike, happy Monday!"
  end

  test "raise error when variable is missing" do
    assert_raise MissingValueError, fn ->
      format("Hi {name}!", %{count: 42})
    end
  end

  test "format number when argument type is `number`" do
    assert format("You have {email_count, number} emails", %{email_count: 1_000}) == "You have 1,000 emails"
  end

  test "format number as percentage when argument type is `number` and format is `percent`" do
    assert format("I'm sure {certainty, number, percent}!", %{certainty: 100}) == "I'm sure 100%!"
  end

  test "format date when argument is `date`" do
    {:ok, birthday} = Calendar.DateTime.new(1984, 04, 26)
    assert format("I was born on {birthday, date}", %{birthday: birthday}) == "I was born on Apr. 26, 1984"
  end

  test "format date in given `format` when argument is `date`" do
    {:ok, birthday} = Calendar.DateTime.new(1984, 04, 26)
    assert format("I was born on {birthday, date, short}", %{birthday: birthday}) == "I was born on 1984-04-26"
  end
end
