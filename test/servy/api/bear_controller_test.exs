defmodule Servy.Api.ServyControllerTest do
  use ExUnit.Case

  test "returns a list of bears in a json type" do
    request = %Servy.Conv{method: "GET", status: nil, path: "/bears", resp_body: ""}
    expected_json = """
    [{"type":"Brown","name":"Teddy","id":1,"hibernating":true},
    {"type":"Black","name":"Smokey","id":2,"hibernating":false},
    {"type":"Brown","name":"Paddington","id":3,"hibernating":false},
    {"type":"Grizzly","name":"Scarface","id":4,"hibernating":true},
    {"type":"Polar","name":"Snow","id":5,"hibernating":false},
    {"type":"Grizzly","name":"Brutus","id":6,"hibernating":false},
    {"type":"Black","name":"Rosie","id":7,"hibernating":true},
    {"type":"Panda","name":"Roscoe","id":8,"hibernating":false},
    {"type":"Polar","name":"Iceman","id":9,"hibernating":true},
    {"type":"Grizzly","name":"Kenai","id":10,"hibernating":false}]
    """

    expected_response = %Servy.Conv{
      headers: %{},
      method: "GET",
      params: %{},
      status: 200,
      path: "/bears",
      resp_content_type: "application/json",
      resp_body: strip_break_line(expected_json)
    }

    assert Servy.Api.BearController.index(request) == expected_response
  end

  def strip_break_line(json) do
    String.replace(json, "\n", "")
  end
end
