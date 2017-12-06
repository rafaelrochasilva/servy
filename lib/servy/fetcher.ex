defmodule Servy.Fetcher do
  @moduledoc """
  Fetcher is used to make async calls to VideoFetcher 
  """

  def async(fun) do
    caller = self()

    # self() will be the same result as the pid after calling spawn
    spawn(fn -> send(caller, {self(), :result, fun.()}) end)
  end

  def get_result(pid) do
    receive do {^pid, :result, filename} -> filename end
  end
end
