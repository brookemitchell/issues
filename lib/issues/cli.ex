defmodule Issues.Cli do
  @default_count 4

  @moduledoc """
  Handle the various command line parsing and dispatch to
  the varous functions that end up generating a tble of the
  last _n_ issues in a github project.
  """

  @spec run([binary]) :: list
  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  argv can be -h or --help, which returns help.

  Otherwise it is a github user name, project name, and
  (optionally) the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if
  help given
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def process(:help) do
    IO.puts("""
    usage:  issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt()
  end

  def process({user, project, count}),
    do:
      Issues.GithubIssues.fetch(user, project)
      |> decode_response()
      |> sort_into_desc_order()
      |> last(count)
      |> Issues.TableFormat.print_table_for_columns(["number", "created_at", "title"])

  @spec sort_into_desc_order(any) :: list
  def sort_into_desc_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from github: #{error["message"]}")
    System.halt(2)
  end

  defp args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_internal_representation(_), do: :help

  defp last(list, count) do
    list |> Enum.take(count) |> Enum.reverse()
  end
end
