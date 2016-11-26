defmodule ICU.MessageFormat.UserValue do
  defstruct [:key, :value]

  alias __MODULE__

  defmodule UnsupportedKeyType do
    defexception message: "Key type not supported for user values. Please use an Atom, a char List or a String."
  end

  defmodule MissingValueError do
    defexception [:message]

    def exception(argument) do
      %MissingValueError{message: "No value provided for argument `#{argument}`"}
    end
  end

  def parse(map_values) do
    map_values |> Enum.map(fn {key, value} ->
      %UserValue{key: key |> to_atom, value: value}
    end)
  end

  def find(user_values, key) do
    user_values |> Enum.find(fn user_value -> user_value.key == key |> to_atom end) || raise MissingValueError, key
  end

  def fetch(user_values, key) do
    find(user_values, key).value
  end

  defp to_atom(key) when is_atom(key),      do: key
  defp to_atom(key) when is_list(key),      do: key |> List.to_atom
  defp to_atom(key) when is_bitstring(key), do: key |> String.to_atom
  defp to_atom(key), do: raise UnsupportedKeyType
end
