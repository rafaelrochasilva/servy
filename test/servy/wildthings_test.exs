defmodule Servy.WildthingsTest do
  use ExUnit.Case

  alias Servy.Bear

  test 'list all bears' do
    expected_bears =   [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black"},
      %Bear{id: 3, name: "Paddington", type: "Brown"},
      %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar"},      
      %Bear{id: 6, name: "Brutus", type: "Grizzly"},
      %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Panda"},
      %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Grizzly"}
    ]

    assert Servy.Wildthings.list_bears == expected_bears
  end

  test 'find a bear by id' do
    assert Servy.Wildthings.find_bear(1) == %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true}
  end
end
