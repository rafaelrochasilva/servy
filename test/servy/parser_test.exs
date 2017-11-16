defmodule Servy.ParserTest do
  use ExUnit.Case

  test "parse request" do
    request = """
    GET /wildzoo HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*\n
    """

    expected_parsed_request =  %Servy.Conv{
      method: "GET",
      status: nil,
      path: "/wildzoo",
      resp_body: ""
    }

    assert Servy.Parser.parse(request) == expected_parsed_request
  end
end
