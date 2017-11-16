defmodule Servy.ConvTest do
  use ExUnit.Case

  test "prints the status message" do
    assert Servy.Conv.status_message(201) == "201 Created"
  end
end
