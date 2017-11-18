defmodule Servy.Parser do
  @moduledoc """
    Parse a given request
  """

  alias Servy.Conv

  def parse(request) do
    [request_string, params_string] = String.split(request, "\n\n")
    [method, path, _] =
      request_string
      |> String.split("\n")
      |> List.first
      |> String.split

    %Conv{method: method, path: path, params: parse_params(params_string)}
  end

  defp parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end
end
