defmodule Servy.FetcherTest do
  use ExUnit.Case, async: true

  test "calls an async task to get a video" do
    Servy.Fetcher.async(fn -> Servy.VideoCam.get_snapshot("camera") end)

    assert Servy.Fetcher.get_result() == "camera-snapshot.jpg"
  end
end

