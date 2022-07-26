defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormat, as: TF

  @simple_test_data [
    [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
    [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
  ]

  @headers [:c1, :c2, :c4]

  describe "TableFormat text layout" do
    setup do
      [
        test_input: @simple_test_data,
        headers: @headers
      ]
    end

    test "split into columns", fixture do
      columns = TF.split_into_columns(fixture.test_input, fixture.headers)
      assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
      assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
    end

    test "column widths", fixture do
      widths =
        TF.split_into_columns(fixture.test_input, fixture.headers)
        |> TF.widths_of()

      assert widths == [5, 6, 7]
    end

    test "correct format string" do
      assert TF.format_for([9, 10, 11]) == "~-9s / ~-10s / ~-11s~n"
    end

    test "output is correct" do
      result =
        capture_io(fn ->
          TF.print_table_for_columns(@simple_test_data, @headers)
        end)

      assert result ==
               "c1    / c2     / c4     \nr1 c1 / r1 c2  / r1+++c4\nr2 c1 / r2 c2  / r2 c4  \nr3 c1 / r3 c2  / r3 c4  \nr4 c1 / r4++c2 / r4 c4  \n"
    end
  end
end
