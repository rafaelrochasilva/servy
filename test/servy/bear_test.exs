defmodule Servy.BearTest do
  use ExUnit.Case

  test 'sort a given names asc' do
    name1 = %{name: "Yogi"}
    name2 = %{name: "Paddington"}

    assert Servy.Bear.sort_asc_by_name(name1, name2) == false
  end

  test 'filters Grizzy bear type' do
    bear = %{type: "Grizzly"}

    assert Servy.Bear.is_grizzly(bear) == true
  end
end
