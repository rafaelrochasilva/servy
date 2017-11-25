defmodule Servy.Api.BearController do
  @moduledoc """
  Returns all responses as a json format
  """
  alias Servy.Wildthings

  def index(conv) do
    json =
      Wildthings.list_bears
      |> Poison.encode!

    %{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
