defmodule Issues.Cli do
  @default_count 4

  @moduledoc """
  Handle the various command line parsing and dispatch to
  the varous functions that end up generating a tble of the
  last _n_ issues in a github project.
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  argv can be -h or --help, which returns help.

  Otherwise it is a github user name, project name, and
  (optionally) the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if
  help given
  """

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [user, project, count], _} ->
        {user, project, count}

      {_, [user, project], _} ->
        {user, project, @default_count}

      _ ->
        :help
    end
  end
end
