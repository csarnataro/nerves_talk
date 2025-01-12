# .dialyzer_ignore.exs
#
# See https://github.com/jeremyjh/dialyxir#elixir-term-format
[
  {"lib/nerves_talk/fwup.ex", :no_return, 31},
  {"lib/nerves_talk/application.ex", :pattern_match, 99}
]
