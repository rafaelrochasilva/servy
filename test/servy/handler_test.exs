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
    Content-Length: 21

    Bears, Lions, Tigers\n
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
    Content-Length: 15

    Page not found!
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "route the parsed request" do
    parsed_request = %{method: "GET", status: nil, path: "/wildzoo", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers\n"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes to a bear path" do
    parsed_request = %{method: "GET", status: nil, path: "/bears", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/bears", resp_body: "Yogi, Panda, Paddington\n"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes an unknow route" do
    parsed_request = %{method: "GET", status: nil, path: "/tigers", resp_body: ""}
    expected_route =  %{method: "GET", status: 404, path: "/tigers", resp_body: "Page not found!"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes to a expecific bear path" do
    parsed_request = %{method: "GET", status: nil, path: "/bears/1", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/bears/1", resp_body: "Bear 1"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "routes with a delete action for deliting a bear" do
    parsed_request = %{method: "DELETE", status: nil, path: "/bears/1", resp_body: ""}
    expected_route =  %{method: "DELETE", status: 403, path: "/bears/1", resp_body: "You can't delete my bears!"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "returns a html page when it exists" do
    parsed_request = %{method: "GET", status: nil, path: "/wildzoo", resp_body: ""}
    expected_route =  %{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers\n"}

    assert Servy.Handler.route(parsed_request) == expected_route
  end

  test "returns a error message when html page does not exists" do
  end

  test "formats the response" do
    route_response =  %{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers\n"}
    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 21

    Bears, Lions, Tigers\n
    """

    assert Servy.Handler.format_response(route_response) == expected_response
  end
end
