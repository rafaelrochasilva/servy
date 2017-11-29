defmodule Servy.HttpServer do
  @moduledoc """
  Receives HTTP requests and returns a HTTP response.
  """

  @doc """
  Public: Starts the server on the given 'port' of localhost. It also create a
  socket to listen for client connections(listen_socket).

  Everytime a new connection happen, the servy gets the client_socket and handles
  it request, generating a html response.
  After the response is generated, the server closes the connection with client,
  and keep listening for more connections.

  Socket Options:
    :binary - open the socket in binary mode and deliver data as binaries.
    packet: :raw - deliver the entire binary without doing any packet handling.
    active: false - receive data when we're ready by calling :gen_tcp.recv/2
    reuseaddr: true - allows reusing the address if the listener crashes
  """

  @spec start(number) :: binary
  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts "\n Listening for connection requests on port #{port}...\n"

    accept_loop(listen_socket)
  end

  @spec accept_loop(port) :: no_return
  defp accept_loop(listen_socket) do
    IO.puts "Waiting to accept a client connection...\n"

    # Suspends (blocks) and waits for a client connection. When a connection is
    # accepted, client_socket is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts "Connection accepted!\n"

    # Receives the request and sends a response over the client socket
    # Uses a process to avoid to lock the socket, while a client is connected.
    spawn(fn -> serve(client_socket) end)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  @spec serve(number) :: no_return
  defp serve(client_socket) do
    client_socket
    |> read_request
    |> generate_response
    |> write_response(client_socket)
  end

  @spec read_request(port) :: any
  defp read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts "Received request:\n"
    IO.puts request

    request
  end

  @spec generate_response(binary) :: binary
  defp generate_response(request) do
    Servy.Handler.handle(request)
  end

  @spec write_response(binary, port) :: {:ok}
  defp write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts "Sent response:\n"
    IO.puts response

    :gen_tcp.close(client_socket)
  end
end
