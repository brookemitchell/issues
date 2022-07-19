defmodule Issues.TableFormat do
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths) do
      puts_one_line_in_columns(headers, format)
      seperator(column_widths)
      puts_in_column(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

  def widths_of(columns) do
    for column <- columns do
      column |> Enum.map(&String.length/1) |> Enum.max()
    end
  end

  def format_for(column_widths) do
    Enum.map_join(column_widths, " / ", &"~-#{&1 + 1}s") <> "~n"
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
