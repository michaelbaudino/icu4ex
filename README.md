# ICU

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `icu4ex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:icu4ex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `icu4ex` is started before your application:

    ```elixir
    def application do
      [applications: [:icu4ex]]
    end
    ```

## Roadmap

* [ ] Implement `plural` support
* [ ] Implement `selectordinal` support
* [ ] Add dates formats (in a separate file)
* [ ] Add times formats (in a separate file)
* [ ] Write [documentation](https://hexdocs.pm/elixir/writing-documentation.html)
* [ ] Write README
* [ ] [Publish to Hex](https://hex.pm/docs/publish)
* [ ] Add continuous integration / deployment [with Travis](https://docs.travis-ci.com/user/languages/elixir/)
* [ ] Add tools like [Inch-CI](https://inch-ci.org), [Credo-CI](http://credo-ci.org/), [HexFaktor](https://beta.hexfaktor.org), ...

## Literature

* [FormatJS message syntax](http://formatjs.io/guides/message-syntax)
* [ICU messages formatting](http://userguide.icu-project.org/formatparse/messages)
* [ICU dates and times formatting](http://userguide.icu-project.org/formatparse/datetime)
* [`format-message` interactive tutorial](https://format-message.github.io/icu-message-format-for-translators/)
