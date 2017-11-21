defmodule BearControllerTest do
  use ExUnit.Case

  test "lists all bears" do
    ul_items = "<ul><li>Brutus - Grizzly</li><li>Kenai - Grizzly</li><li>Scarface - Grizzly</li></ul>"
    parsed_request = %Servy.Conv{method: "GET", status: nil, path: "/bears", resp_body: ""}
    expected_route = %Servy.Conv{method: "GET", status: 200, path: "/bears", resp_body: ul_items}

    assert Servy.BearController.index(parsed_request) == expected_route
  end

  test "routes to a expecific bear path" do
    parsed_request = %Servy.Conv{method: "GET", status: nil, path: "/bears/1", resp_body: ""}
    expected_route = %Servy.Conv{method: "GET", status: 200, path: "/bears/1", resp_body: "<h1>Teddy 1: Brown</h1>"}
    params = Map.put(%{}, "id", 1)

    assert Servy.BearController.show(parsed_request, params) == expected_route
  end

  test "routes to a expecific bear path passing a string id" do
    parsed_request = %Servy.Conv{method: "GET", status: nil, path: "/bears/1", resp_body: ""}
    expected_route = %Servy.Conv{method: "GET", status: 200, path: "/bears/1", resp_body: "<h1>Teddy 1: Brown</h1>"}
    params = Map.put(%{}, "id", "1")

    assert Servy.BearController.show(parsed_request, params) == expected_route
  end

  test "routes a POST action for creating a new bear" do
    parsed_request = %Servy.Conv{
      method: "POST",
      status: nil,
      path: "/bears",
      resp_body: "",
      params: %{
        "name" => "Baloo",
        "type" => "Brown"
      }
    }

    expected_route = %Servy.Conv{
      method: "POST",
      status: 201,
      path: "/bears",
      resp_body: "Created a Brown bear named Baloo!",
      params: %{"name" => "Baloo", "type" => "Brown"}
    }

    assert Servy.BearController.create(parsed_request) == expected_route
  end

  test "routes with a delete action for deliting a bear" do
    parsed_request = %Servy.Conv{method: "DELETE", status: nil, path: "/bears/1", resp_body: ""}
    expected_route = %Servy.Conv{method: "DELETE", status: 403, path: "/bears/1", resp_body: "You can't delete my bears!"}

    assert Servy.BearController.delete(parsed_request) == expected_route
  end
end
