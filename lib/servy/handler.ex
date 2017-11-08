defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [header, _, _, _, body, _] = String.split(request, "\n")
    [method, path, _] = header |> String.split

    %{ method: method, path: path, resp_body: body }
  end

  def route(conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  def format_response(%{ method: _, path: _, resp_body: resp_body }) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end
end
