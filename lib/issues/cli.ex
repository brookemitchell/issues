defmodule Issues.Cli do
  @default_count 4

  @moduledoc """
  Handle the various command line parsing and dispatch to
  the varous functions that end up generating a tble of the
  last _n_ issues in a github project.
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def process(:help) do
    IO.puts("""
    usage:  issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt()
  end

  def process({user, project, _count}) do
    # Issues.GithubIssues.fetch(user, project)
    1
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

  defp args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_internal_representation(_) do
    :help
  end
end
