defmodule Servy.PledgeController do

  @moduledoc """
  Handles requests to Pledges
  """
  alias Servy.PledgeServer

  def index(conv) do
    pledges = PledgeServer.recent_pledges()
              |> Enum.map(&stringfy_pledge/1)
              |> Enum.join(", ")

    %{conv | status: 200, resp_body: pledges}
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    PledgeServer.create_pledge(name, String.to_integer(amount))

    %{conv | status: 201, resp_body: "#{name} pledged #{amount}!"}
  end

  defp stringfy_pledge({name, amount}) do
    "#{name} #{amount}"
  end
end
