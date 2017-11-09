defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split

    %{ method: method, path: path, resp_body: ""}
  end

  def route(%{method: "GET", path: "/wildzoo"} = conv) do
    %{ conv | resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{method: "GET", path: "/bear"} = conv) do
    %{ conv | resp_body: "Yogi, Panda, Paddington" }
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
