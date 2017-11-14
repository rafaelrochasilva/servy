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

    %{ method: method, status: nil, path: path, resp_body: ""}
  end

  def route(%{method: "GET", path: "/bears/" <> _id} = conv) do
    %{ conv | status: 200, resp_body: "Bear 1" }
  end

  def route(%{method: "GET", path: path} = conv) do
    case read_file(path) do
      {:ok, content} ->
        %{ conv | status: 200, resp_body: content }

      {:error, :enoent} ->
        %{ conv | status: 404, resp_body: "Page not found!" }

      {:erro, reason} ->
        %{ conv | status: 500, resp_body: "File error: #{reason}" }
    end
  end

  def route(%{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %{ conv | status: 403, resp_body: "You can't delete my bears!" }
  end

  def format_response(%{ status: code, resp_body: resp_body }) do
    """
    HTTP/1.1 #{code} #{status_reason(code)}
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end

  defp read_file(path) do
    Path.expand("../pages", __DIR__)
    |> Path.join("#{path}.html")
    |> File.read
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
