defmodule Servy.VideoCamTest do
  use ExUnit.Case

  test "takes a snapshot from a given cam" do
    assert Servy.VideoCam.get_snapshot("cam1") == "cam1-snapshot.jpg"
  end
end
