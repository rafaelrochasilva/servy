defmodule Servy.Bear do
  @moduledoc """
  The Bear module is a data abstraction for a bear. By this we can define some
  properties that will be used for each entity of bear.
  """

  defstruct [id: nil, name: "", type: "", hibernating: false]

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end

  def sort_asc_by_name(bear1, bear2) do
    bear1.name <= bear2.name
  end
end
