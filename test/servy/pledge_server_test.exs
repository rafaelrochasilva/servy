defmodule Servy.PledgeServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pledge} = Servy.PledgeServer.start_link()
    {:ok, process: pledge}
  end

  test "creates a pledge for a given name and amount" do
    assert Regex.match?(~r/pledge/, Servy.PledgeServer.create_pledge("larry", 10))
  end

  test "returns a cached list from a external service when there is no pledges" do
    assert Servy.PledgeServer.recent_pledges() == [{"wilma", 35}, {"mike", 10}]
  end

  test "returns the last 3 recent pledges" do
    Servy.PledgeServer.create_pledge("larry", 10)
    Servy.PledgeServer.create_pledge("bruce", 20)
    Servy.PledgeServer.create_pledge("anna", 50)
    Servy.PledgeServer.create_pledge("joe", 30)

    expected_response = [{"joe", 30}, {"anna", 50}, {"bruce", 20}]

    assert Servy.PledgeServer.recent_pledges() == expected_response
  end

  test "returns the total of pledges" do
    Servy.PledgeServer.create_pledge("larry", 10)
    Servy.PledgeServer.create_pledge("bruce", 20)
    Servy.PledgeServer.create_pledge("anna", 50)
    Servy.PledgeServer.create_pledge("joe", 30)

    assert Servy.PledgeServer.total_pledged() == 155
  end
end
