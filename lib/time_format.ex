defmodule ICU.TimeFormat do
  alias ICU.LocaleNotFound
  alias ICU.FormatNotFound

  # Shamelessly copied from https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/en.yml
  @all_format_strings %{
    en: %{
      "short"  => "%I:%M%P",
      "medium" => "%H:%M",
      "long"   => "%H:%M:%S",
      "full"   => "%H:%M:%S"
    },
    fr: %{
      "short"  => "%Hh%M",
      "medium" => "%Hh%M %Ss",
      "long"   => "%Hh %Mmin %Ss",
      "full"   => "%Hh %Mmin %Ss"
    }
  }

  def format(time, locale, format_name \\ "medium") do
    time |> Calendar.Strftime.strftime!(format_string(locale, format_name), locale)
  end

  defp format_string(locale, format_name) do
    @all_format_strings
      |> Map.get_lazy(locale, fn -> raise LocaleNotFound, locale end)
      |> Map.get_lazy(format_name, fn -> raise FormatNotFound, format_name end)
  end
end
