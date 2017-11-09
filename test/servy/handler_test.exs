defmodule HandlerTest do
  use ExUnit.Case

  test "handler response" do
    request = """
    GET /wildzoo HTTP/1.1
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

  test "handler a unknow path request" do
    request = """
    GET /tigers HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    expected_response = """
    HTTP/1.1 404 Not Found
    Content-Type: text/html
    Content-Length: 16

    No /tigers here!
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

    assert Servy.Handler.parse(request) == %{ method: "GET", status: nil, path: "/wildzoo", resp_body: "" }
  end

  test "route the parsed request" do
    parsed_request = %{method: "GET", status: nil, path: "/wildzoo", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes to a bear path" do
    parsed_request = %{method: "GET", status: nil, path: "/bears", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/bears", resp_body: "Yogi, Panda, Paddington"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes an unknow route" do
    parsed_request = %{method: "GET", status: nil, path: "/tigers", resp_body: ""}
    expected_route =  %{method: "GET", status: 404, path: "/tigers", resp_body: "No /tigers here!"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "formats the response" do
    route_response =  %{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers"}
    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """

    assert Servy.Handler.format_response(route_response) == expected_response
  end
end
