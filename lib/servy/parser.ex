defmodule Servy.Parser do
  @moduledoc """
    Parse a given request
  """

  alias Servy.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split

    %Conv{method: method, path: path}
  end
end
