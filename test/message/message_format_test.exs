defmodule ICUTest.MessageFormat do
  use ExUnit.Case
  doctest ICU.MessageFormat

  import ICU.MessageFormat
  alias ICU.MessageFormat.UserValue.MissingValueError
  alias ICU.MessageFormat.UserValue.UnsupportedKeyType
  alias ICU.MessageFormat.SelectOption.UnavailableOption
  alias ICU.MessageFormat.ParseError

  setup do
    {:ok, birthday} = Calendar.DateTime.Parse.rfc2822_utc("Thu, 26 Apr 1984 12:15:00 +0200")
    {:ok, birthday: birthday}
  end

  test "empty strings are unchanged" do
    assert format("") == ""
  end

  test "heading and trailing spaces are unchanged" do
    assert format("  Good morning.  ") == "  Good morning.  "
  end

  test "unclosed curly brace raises a parsing error" do
    assert_raise ParseError, fn -> format("Hi {oops") end
  end

  test "`simple` arguments are replaced using values" do
    assert format("Good morning {my_name}", %{my_name: "Mike"}) == "Good morning Mike"
  end

  test "values keys can be either atoms, strings or char lists" do
    assert format("{name} {age} {gender}", %{:name => "Mike", "age" => 42, 'gender' => :male}) == "Mike 42 male"
  end

  test "commas can be used as non-interpolated strings" do
    assert format("Good morning, {title}", %{title: "Sir"}) == "Good morning, Sir"
  end

  test "spaces around arguments are unchanged" do
    assert format("Good    {subject} Sir", %{subject: "morning"}) == "Good    morning Sir"
  end

  test "when an expected value is missing, an error is raised" do
    assert_raise MissingValueError, fn -> format("Hi {name}", %{}) end
  end

  test "when an value has a key in unexpected type, an error is raised" do
    assert_raise UnsupportedKeyType, fn -> format("Hi {name}", %{42 => "wat?"}) end
  end

  test "`number` arguments default format is properly localized" do
    assert format("You have {count, number} emails", %{count: 1_000}) == "You have 1,000 emails"
  end

  test "`number` arguments percent format is supported" do
    assert format("I am {certainty, number, percent} sure", %{certainty: 42}) == "I am 42% sure"
  end

  test "`select` arguments are supported" do
    message = "Call me {gender, select, male {Sir} female {Madam}}!"
    assert format(message, %{gender: :male}) == "Call me Sir!"
    assert format(message, %{gender: :female}) == "Call me Madam!"
  end

  test "`select` arguments output can be ICU messages themselves (a.k.a. nested messages)" do
    message = "Call me {gender, select, male {Sir {name}} female {Madam {name}}}!"
    assert format(message, %{gender: :male, name: "Mike"}) == "Call me Sir Mike!"
    assert format(message, %{gender: :female, name: "Carole"}) == "Call me Madam Carole!"
  end

  test "`select` arguments keys can be either atoms, strings or char lists" do
    message = "Call me {gender, select, male {Sir} female {Madam}}!"
    assert format(message, %{gender: :male}) == "Call me Sir!"
    assert format(message, %{gender: "male"}) == "Call me Sir!"
    assert format(message, %{gender: 'male'}) == "Call me Sir!"
  end

  test "when an unexpected `select` option is given, an error is raised" do
    assert_raise UnavailableOption, fn -> format("Hi {age, select, young {kid} elderly {dear}}", %{age: :adult}) end
  end

  test "when an `other` option is provided, it is used when no other option matches" do
    message = "Call me {gender, select, male {Sir} female {Madam} other {someone else}}."
    assert format(message, %{gender: :transgender}) == "Call me someone else."
  end

  test "`date` messages in default format are properly localized", %{birthday: birthday} do
    assert format("I was born on {birthday, date}", %{birthday: birthday}) == "I was born on Apr. 26, 1984"
  end

  test "`date` messages in pre-defined formats are supported", %{birthday: birthday} do
    assert format("I was born on {birthday, date, short}", %{birthday: birthday}) == "I was born on 1984-04-26"
  end

  test "`time` messages in default format are properly localized", %{birthday: birthday} do
    assert format("I was born at {birthday, time}", %{birthday: birthday}) == "I was born at 10:15"
  end

  test "`time` messages in pre-defined formats are supported", %{birthday: birthday} do
    assert format("I was born at {birthday, time, short}", %{birthday: birthday}) == "I was born at 10:15am"
  end
end
