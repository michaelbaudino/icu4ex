defmodule ICU.MessageFormat.SelectOption do
  defstruct [:key, :message]

  alias __MODULE__

  defmodule UnavailableOption do
    defexception [:message]

    def exception(key) do
      %UnavailableOption{message: "No option available for key `#{key}`"}
    end
  end

  def parse(options) do
    options |> Enum.map(fn {key, message} ->
      %SelectOption{key: key |> to_atom, message: message}
    end)
  end

  def find(select_options, key) do
    atomized_key = key |> to_atom
    select_options |> Enum.find(fn select_option ->
      select_option.key == atomized_key
    end) || if atomized_key != :other, do: find(select_options, :other), else: raise UnavailableOption, key
  end

  def fetch(select_options, key) do
    find(select_options, key).message
  end

  defp to_atom(key) when is_atom(key),      do: key
  defp to_atom(key) when is_list(key),      do: key |> List.to_atom
  defp to_atom(key) when is_bitstring(key), do: key |> String.to_atom
end
