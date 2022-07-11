defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli,
    only: [
      parse_args: 1,
      sort_into_desc_order: 1
    ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) ==
             {"user", "project", 99}
  end

  test "count defaulted if two given" do
    assert parse_args(["user", "project"]) ==
             {"user", "project", 4}
  end

  test "sort desc orders the correct way" do
    result = sort_into_desc_order(fake_created_at_list(["c", "a", "b"]))

    issues = for issue <- result, do: Map.get(issue, "created_at")

    assert issues == ~w{c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values,
        do: %{"created_at" => value, "other_data" => "xxxx"}
  end
end
