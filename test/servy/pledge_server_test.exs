defmodule Servy.PledgeServerTest do
  use ExUnit.Case

  test "creates a pledge for a given name and amount" do
    pid = Servy.PledgeServer.start()

    assert Regex.match?(~r/pledge/, Servy.PledgeServer.create_pledge("larry", 10))
    Process.exit(pid, :kill)
  end

  test "returns an empty list when there is no pledges" do
    pid = Servy.PledgeServer.start()

    assert Servy.PledgeServer.recent_pledges() == []
    Process.exit(pid, :kill)
  end

  test "returns the last 3 recent pledges" do
    pid = Servy.PledgeServer.start()
    Servy.PledgeServer.create_pledge("larry", 10)
    Servy.PledgeServer.create_pledge("bruce", 20)
    Servy.PledgeServer.create_pledge("anna", 50)
    Servy.PledgeServer.create_pledge("joe", 30)

    expected_response = [{"joe", 30}, {"anna", 50}, {"bruce", 20}]

    assert Servy.PledgeServer.recent_pledges() == expected_response
    Process.exit(pid, :kill)
  end

  test "returns the total of pledges" do
    pid = Servy.PledgeServer.start()
    Servy.PledgeServer.create_pledge("larry", 10)
    Servy.PledgeServer.create_pledge("bruce", 20)
    Servy.PledgeServer.create_pledge("anna", 50)
    Servy.PledgeServer.create_pledge("joe", 30)

    assert Servy.PledgeServer.total_pledged() == 110
    Process.exit(pid, :kill)
  end
end
