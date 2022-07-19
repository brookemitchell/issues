defmodule Issues.TableFormat do
  @doc """
  Takes a list of row data, where each row is a map, and a list of
  headers. Prints a table to STDOUT of the data from each row identified
  by each header. That is, each header identifies a column, and those
  columns are extracted and printed from the rows. We calculate the
  width of each column to fit the longest element in that column.
  """
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      seperator(column_widths)
      puts_in_column(data_by_columns, format)
    end
  end

  @doc """
  Given a list of rows, where each row contains a keyed list of columns,
  return a list of containing lists of the data in each column. The
  `headers` column contains the list of columns to extract

  ## Example

  iex> list = [Enum.into([{"a", "1"},{"b", "2"},{"c", "3"}], %{}),
  ...>         Enum.into([{"a", "4"},{"b", "5"},{"c", "6"}], %{})]
  ...> Issues.TableFormat.split_into_columns(list, [ "a", "b", "c" ])
  [ ["1", "4"], ["2", "5"], ["3", "6"] ]
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
  Returns a binary (string) version of our parameter.
  ## Examples
  iex> Issues.TableFormat.printable("a")
  "a"
  iex> Issues.TableFormat.printable(99)
  "99"

  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns do
      column |> Enum.map(&String.length/1) |> Enum.max()
    end
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " / ", &"~-#{&1}s") <> "~n"
  end

  def seperator(column_widths) do
    Enum.map_join(column_widths, "-+-", &List.duplicate("-", &1))
  end

  def puts_in_column(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.each(&puts_one_line_in_columns(&1, format))
  end

  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
