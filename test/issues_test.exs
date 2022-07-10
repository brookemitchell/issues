defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  test ":help returned by option parsing with -h and --help options" do
    assert Issues.Cli.parse_args(["-h", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert Issues.Cli.parse_args(["user", "project", "99"]) ==
             {"user", "project", 99}
  end

  test "count defaulted if two given" do
    assert Issues.Cli.parse_args(["user", "project"]) ==
             {"user", "project", 4}
  end
end
