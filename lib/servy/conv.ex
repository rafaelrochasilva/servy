defmodule Servy.Conv do
  @moduledoc """
  Conv is a data abstraction for deling with http requests and responses.
  """

  defstruct [
    method: "",
    path: "",
    resp_body: "",
    resp_content_type: "text/html",
    status: nil,
    params: %{},
    headers: %{}
  ]

  @spec status_message(integer) :: binary
  def status_message(code) do
    "#{code} #{status_reason(code)}"
  end

  @spec status_reason(integer) :: binary
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
