defmodule Servy.ParserTest do
  use ExUnit.Case, async: true

  test "parse a GET request to wildzoo" do
    request = """
    GET /wildzoo HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    expected_parsed_request =  %Servy.Conv{
      method: "GET",
      status: nil,
      path: "/wildzoo",
      resp_body: "",
      headers: %{
        "Host" => "example.com",
        "User-Agent" => "ExampleBrowser/1.0",
        "Accept" => "*/*"
      }
    }

    assert Servy.Parser.parse(request) == expected_parsed_request
  end

  test "parse a POST request to create a bear" do
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
    expected_parsed_request = %Servy.Conv{
      method: "POST",
      status: nil,
      path: "/bears",
      resp_body: "",
      params: %{
        "name" => "Baloo",
        "type" => "Brown"
      },
      headers: %{
        "Host" => "example.com",
        "User-Agent" => "ExampleBrowser/1.0",
        "Accept" => "*/*",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Content-Length" => "21"
      }
    }

    assert Servy.Parser.parse(request) == expected_parsed_request
  end
end
