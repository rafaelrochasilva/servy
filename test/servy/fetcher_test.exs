defmodule Servy.FetcherTest do
  use ExUnit.Case

  test "calls an async task to get a video" do
    Servy.Fetcher.async("camera")

    assert Servy.Fetcher.get_result() == "camera-snapshot.jpg"
  end
end

