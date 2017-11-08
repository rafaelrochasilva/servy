defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    lines_request = request_by_line(request)
    header_request = header(lines_request)

    %{
      method: header_method(header_request),
      path: header_path(header_request),
      resp_body: body(lines_request)
    }
  end

  def route(%{ method: method, path: path, resp_body:_ }) do
    %{
      method: method,
      path: path,
      resp_body: "Bears, Lions, Tigers"
    }
  end

  def format_response(%{ method: method, path: path, resp_body: resp_body }) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end

  defp request_by_line(request) do
    String.split(request, "\n")
  end

  defp header(request) do
    request
    |> List.first
    |> String.split
  end

  defp header_method(header) do
    Enum.at(header, 0)
  end

  defp header_path(header) do
    Enum.at(header, 1)
  end

  defp body(request) do
    List.last(request)
  end
end
