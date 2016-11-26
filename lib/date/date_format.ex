defmodule ICU.DateFormat do
  alias ICU.LocaleNotFound
  alias ICU.FormatNotFound

  # Should be in a separate file and include more locales
  @all_format_strings %{
    en: %{
      "short"  => "%Y-%m-%d",
      "medium" => "%b. %d, %Y",
      "long"   => "%B %d, %Y",
      "full"   => "%A, %B %d, %Y",
    },
    fr: %{
      "short"  => "%d/%m/%Y",
      "medium" => "%d %b %Y",
      "long"   => "%d %B %Y",
      "full"   => "%A %d %B %Y",
    }
  }

  def format(date, locale, format_name \\ "medium") do
    date |> Calendar.Strftime.strftime!(format_string(locale, format_name), locale)
  end

  defp format_string(locale, format_name) do
    @all_format_strings
      |> Map.get_lazy(locale, fn -> raise LocaleNotFound, locale end)
      |> Map.get_lazy(format_name, fn -> raise FormatNotFound, format_name end)
  end
end
