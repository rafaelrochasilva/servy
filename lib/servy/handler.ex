defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    format_response(request)
  end

  def parse(request) do
    lines_request = request_by_line(request )
    header_request = header(lines_request)

    %{
      method: header_method(header_request),
      path: header_path(header_request),
      resp_body: body(lines_request)
    }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

  def request_by_line(request) do
    String.split(request, "\n")
  end

  def header(request) do
    request
    |> List.first
    |> String.split
  end

  def header_method(header) do
    Enum.at(header, 0)
  end

  def header_path(header) do
    Enum.at(header, 1)
  end

  def body(request) do
    List.last(request)
  end
end
