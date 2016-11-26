defmodule ICU.NumberFormat do
  # TODO: please implement me properly (maybe using https://github.com/danielberkompas/number)
  def format(number, locale \\ :en)
  def format(number, locale) when is_integer(number), do: number |> Integer.to_string |> format(locale)
  def format(number, locale), do: separate(number, 3, separator(locale))

  def format_percent(number, locale \\ :en) do
    format(number, locale) <> "%"
  end

  defp separator(locale) do
    case locale do
      :fr -> "."
      :en -> ","
      _   -> ","
    end
  end

  defp separate(number_as_string, chunk_size, separator) do
    case String.split_at(number_as_string, -chunk_size) do
      {"", chunk}   -> chunk
      {rest, chunk} -> separate(rest, chunk_size, separator) <> separator <> chunk
    end
  end
end
