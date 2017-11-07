defmodule HandlerTest do
  use ExUnit.Case

  test "handler response" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "parse request" do
    request = """
    GET /wildzoo HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    assert Servy.Handler.parse(request) == %{ method: "GET", path: "/wildzoo", resp_body: "" }
  end
end
