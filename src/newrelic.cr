require "./newrelic/*"
require "any_bar"

api_keys = File.read(File.expand_path "~/.newrelic_keys").lines.map &.chomp

any_bar = AnyBar::Client.new
any_bar.color = "question"

checker = StatusChecker.new
begin
  api_keys.map do |key|
    future { checker.check(key) }
  end.map &.get
rescue ex
  any_bar.color = "exclamation"
  raise ex
else
  if checker.warn
    any_bar.color = "orange"
  elsif checker.error
    any_bar.color = "red"
  else
    any_bar.color = "green"
  end
end
