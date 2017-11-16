defmodule Servy.Conv do
  defstruct [
    method: "",
    path: "",
    resp_body: "",
    status: nil,
    params: %{},
    headers: %{}
  ]

  def status_message(code) do
    "#{code} #{status_reason(code)}"
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
