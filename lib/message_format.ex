defmodule ICU.MessageFormat do
  alias ICU.NumberFormat
  alias ICU.DateFormat
  alias ICU.TimeFormat

  defmodule MissingValueError do
    defexception [:message]

    def exception(argument) do
      %MissingValueError{message: "No value provided for argument `#{argument}`"}
    end
  end

  def format(message, values \\ %{}) do
    Regex.replace(~r/{([^}]*)}/, message, &(handle_capture(&1, &2, values)), global: true)
  end

  defp handle_capture(_full_match, argument, values) do
    argument |> String.split(", ") |> interpolate_argument(values)
  end

  defp interpolate_argument([key], values) do
    values |> find_indifferent(key)
  end

  defp interpolate_argument([key, "number"], values) do
    values |> find_indifferent(key) |> NumberFormat.format
  end

  defp interpolate_argument([key, "number", "percent"], values) do
    values |> find_indifferent(key) |> NumberFormat.format_percent
  end

  defp interpolate_argument([key, "date"], values) do
    interpolate_argument([key, "date", "medium"], values)
  end

  defp interpolate_argument([key, "date", format], values) do
    values |> find_indifferent(key) |> DateFormat.format(:en, format)
  end

  defp interpolate_argument([key, "time"], values) do
    interpolate_argument([key, "time", "medium"], values)
  end

  defp interpolate_argument([key, "time", format], values) do
    values |> find_indifferent(key) |> TimeFormat.format(:en, format)
  end

  defp find_indifferent(values, key) do
    values[key] || values[String.to_atom(key)] || raise MissingValueError, key
  end
end
