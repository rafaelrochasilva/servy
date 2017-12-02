defmodule HandlerTest do
  use ExUnit.Case, async: true

  test "handler a GET request for wildzoo" do
    request = """
    GET /wildzoo HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 21

    Bears, Lions, Tigers\n
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "handler a GET request for listing all bears and responde with HTML" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 331

    <ul>\n  \n    <li>Brutus - Grizzly</li>\n  \n    <li>Iceman - Polar</li>\n  \n    <li>Kenai - Grizzly</li>\n  \n    <li>Paddington - Brown</li>\n  \n    <li>Roscoe - Panda</li>\n  \n    <li>Rosie - Black</li>\n  \n    <li>Scarface - Grizzly</li>\n  \n    <li>Smokey - Black</li>\n  \n    <li>Snow - Polar</li>\n  \n    <li>Teddy - Brown</li>\n  \n</ul>\n
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "handler a GET request for listing all bears and responde with JSON" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    json_response = """
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
    |> String.replace("\n", "")

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 605

    #{json_response}
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "handler a unknow GET request" do
    request = """
    GET /tigers HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_response = """
    HTTP/1.1 404 Not Found
    Content-Type: text/html
    Content-Length: 15

    Page not found!
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "handler a POST request to create a new bear" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown\r
    """

    expected_response = """
    HTTP/1.1 201 Created
    Content-Type: text/html
    Content-Length: 33

    Created a Brown bear named Baloo!
    """

    assert Servy.Handler.handle(request) == expected_response
  end

  test "handler a GET snapshot request" do
    request = """
    GET /snapshots HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 55

    cam1-snapshot.jpg, cam2-snapshot.jpg, cam3-snapshot.jpg
    """

    assert Servy.Handler.handle(request) == expected_response
  end


  test "formats the response" do
    route_response =  %Servy.Conv{
      method: "GET",
      status: 200,
      path: "/wildzoo",
      resp_body: "Bears, Lions, Tigers\n"
    }
    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 21

    Bears, Lions, Tigers\n
    """

    assert Servy.Handler.format_response(route_response) == expected_response
  end
end
