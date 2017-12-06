defmodule Servy.TrackerTest do
  use ExUnit.Case, async: true

  test "get a wildthing location" do
    expected_location = %{lat: "44.4280 N", lng: "110.5885 W"}

    assert Servy.Tracker.get_location("roscoe") == expected_location
  end
end
