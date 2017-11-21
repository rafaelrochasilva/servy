defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("../pages", __DIR__)

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> Servy.Parser.parse
    |> route
    |> format_response
  end

  def format_response(%Conv{status: code, resp_body: resp_body}) do
    """
    HTTP/1.1 #{Conv.status_message(code)}
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end

  defp route(%Conv{method: "GET", path: "/"} = conv) do
    BearController.index(conv)
  end

  defp route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  defp route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv)
  end

  defp route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv)
  end

  defp route(%Conv{method: "GET", path: path} = conv) do
    path
    |> read_file
    |> handle_file(conv)
  end

  defp handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  defp handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "Page not found!"}
  end

  defp handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  defp read_file(path) do
    @pages_path
    |> Path.join("#{path}.html")
    |> File.read
  end
end
