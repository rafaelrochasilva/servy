defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests

  When a new Http request is made to our server, it processes the request by
  transforming the request, by parsing it. After parsing it, the request is
  redirect for the proper route. For each route we process the request and
  return its response.
  """

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam

  @pages_path Path.expand("../pages", __DIR__)

  @type conv :: %{
    __struct__: Servy.Conv,
    method: binary,
    path: binary,
    resp_body: binary,
    resp_content_type: binary,
    status: integer,
    params: %{},
    headers: %{}
  }

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> Servy.Parser.parse
    |> route
    |> format_response
  end

  @spec format_response(conv) :: binary
  def format_response(%Conv{status: code, resp_body: resp_body} = conv) do
    """
    HTTP/1.1 #{Conv.status_message(code)}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end

  @spec route(conv) :: conv
  defp route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    Servy.Fetcher.async(fn -> VideoCam.get_snapshot("cam1") end)
    Servy.Fetcher.async(fn -> VideoCam.get_snapshot("cam2") end)
    Servy.Fetcher.async(fn -> VideoCam.get_snapshot("cam3") end)

    snap1 = Servy.Fetcher.get_result()
    snap2 = Servy.Fetcher.get_result()
    snap3 = Servy.Fetcher.get_result()

    list_snap =
      [snap1, snap2, snap3]
      |> Enum.reduce(fn(item, acc) -> acc <> ", " <> item end)

    %{conv | status: 200, resp_body: list_snap}
  end

  defp route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  defp route(%Conv{method: "GET", path: "/bears"} = conv) do
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
