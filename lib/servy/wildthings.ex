defmodule Servy.Wildthings do
  @moduledoc """
  Wildthings is an interface responsable to fetch all related animals. By this 
  we can access the list of bears, or find a expecific bear.
  """

  alias Servy.Bear

  @type bear :: %{
    __struct__: Servy.Bear,
    id: integer,
    name: binary,
    type: binary,
    hibernating: boolean
  }

  @spec list_bears() :: [bear]
  def list_bears do
    [
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
  end

  @spec find_bear(integer) :: bear
  def find_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(bear) -> bear.id == id end)
  end

  @spec find_bear(binary) :: bear
  def find_bear(id) when is_binary(id) do
    id = String.to_integer(id)
    Enum.find(list_bears(), fn(bear) -> bear.id == id end)
  end
end
