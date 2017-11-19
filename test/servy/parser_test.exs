defmodule Servy.ParserTest do
  use ExUnit.Case

  test "parse a GET request" do
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
      resp_body: "",
      headers: %{
        "Host" => "example.com",
        "User-Agent" => "ExampleBrowser/1.0",
        "Accept" => "*/*"
      }
    }

    assert Servy.Parser.parse(request) == expected_parsed_request
  end

  test "parse a POST request" do
    request = """
    POST /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Baloo&type=Brown
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
