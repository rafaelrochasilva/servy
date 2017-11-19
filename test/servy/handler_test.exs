defmodule HandlerTest do
  use ExUnit.Case

  test "handler a GET request" do
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

  test "handler a unknow GET request" do
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

  test "handler a POST request" do
    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Baloo&type=Brown
    """

    expected_response = """
    HTTP/1.1 201 Created
    Content-Type: text/html
    Content-Length: 33

    Created a Brown bear named Baloo!
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "formats the response" do
    route_response =  %Servy.Conv{method: "GET", status: 200, path: "/wildzoo", resp_body: "Bears, Lions, Tigers\n"}
    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 21

    Bears, Lions, Tigers\n
    """

    assert Servy.Handler.format_response(route_response) == expected_response
  end
end
