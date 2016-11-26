defmodule ICU.MessageFormat do
  alias ICU.NumberFormat
  alias ICU.DateFormat
  alias ICU.TimeFormat
  alias ICU.MessageFormat.UserValue
  alias ICU.MessageFormat.SelectOption

  defmodule ParseError do
    defexception [:message]

    def exception({message, reason}) do
      %ParseError{message: "Could not parse message `#{message}` (#{parse(reason)})"}
    end

    defp parse({_line, :icu_message_parser, errors}) do
      errors |> Enum.join
    end
  end

  def format(message, values \\ %{}), do: parse(message) |> process(UserValue.parse(values))

  defp parse(message) do
    {:ok, tokens, _} = message |> to_char_list |> :icu_message_lexer.string
    case :icu_message_parser.parse(tokens) do
      {:ok, ast}       -> ast
      {:error, reason} -> raise ParseError, {message, reason}
    end
  end

  defp process(message_ast, user_values) do
    message_ast |> Enum.map_join(fn ast_node ->
      interpolate(ast_node, user_values)
    end)
  end

  defp interpolate({:simple, key}, user_values),           do: UserValue.fetch(user_values, key)
  defp interpolate({:string, key}, _user_values),          do: key |> to_string
  defp interpolate({:number, key}, user_values),           do: UserValue.fetch(user_values, key) |> NumberFormat.format
  defp interpolate({:number, key, :percent}, user_values), do: UserValue.fetch(user_values, key) |> NumberFormat.format_percent
  defp interpolate({:date, key}, user_values),             do: UserValue.fetch(user_values, key) |> DateFormat.format(:en)
  defp interpolate({:date, key, format}, user_values),     do: UserValue.fetch(user_values, key) |> DateFormat.format(:en, format |> to_string)
  defp interpolate({:time, key}, user_values),             do: UserValue.fetch(user_values, key) |> TimeFormat.format(:en)
  defp interpolate({:time, key, format}, user_values),     do: UserValue.fetch(user_values, key) |> TimeFormat.format(:en, format |> to_string)
  defp interpolate({:select, key, options}, user_values)   do
    selected_option_key = UserValue.fetch(user_values, key)
    SelectOption.parse(options) |> SelectOption.fetch(selected_option_key) |> process(user_values)
  end
end
