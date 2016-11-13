defmodule ICU do
  defmodule LocaleNotFound do
    defexception [:message]

    def exception(locale) do
      %LocaleNotFound{message: "The following locale is either invalid or not-supported: `#{locale}`"}
    end
  end

  defmodule FormatNotFound do
    defexception [:message]

    def exception(format_name) do
      %FormatNotFound{message: "The following format is not-supported: `#{format_name}`"}
    end
  end
end
