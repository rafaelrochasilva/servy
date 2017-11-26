defmodule Servy.Parser do
  @moduledoc """
    Parse a given request
  """

  alias Servy.Conv

  def parse(request) do
    [request_string, params_string] = String.split(request, "\r\n\r\n")

    [request_line | header_lines] = String.split(request_string, "\r\n")

    [method, path, _] = String.split(request_line)

    %Conv{
      method: method,
      path: path,
      params: parse_params(params_string),
      headers: parse_headers(header_lines, %{})
    }
  end

  defp parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  defp parse_headers([], headers), do: headers

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")

    new_headers = Map.put(headers, key, value)
    parse_headers(tail, new_headers)
  end
end
