defmodule Servy.Conv do
  defstruct [
    method: "",
    path: "",
    resp_body: "",
    status: nil,
    params: %{}
  ]

  def status_code_message do
  end

end
