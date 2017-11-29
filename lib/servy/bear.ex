defmodule Servy.Bear do
  @moduledoc """
  The Bear module is a data abstraction for a bear. By this we can define some
  properties that will be used for each entity of bear.
  """

  defstruct [id: nil, name: "", type: "", hibernating: false]

  @type bear :: %__MODULE__{
    id: integer,
    name: binary,
    type: binary,
    hibernating: boolean
  }

  @spec is_grizzly(bear) :: boolean
  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end

  @spec sort_asc_by_name(bear, bear) :: boolean
  def sort_asc_by_name(bear1, bear2) do
    bear1.name <= bear2.name
  end
end
