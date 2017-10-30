defmodule Documentr.Logger do
  use HTTPotion.Base

  def process_url(url) do
    "http://localhost:4000/v1/api/path"
  end

  def process_request_headers(headers) do
    Dict.put [Accepts: "application/json", "Content-Type": "application/json"], :"User-Agent", "github-potion"
  end

  def post(body), do: request(:post, "", turn_body_to_options(body))

  defp turn_body_to_options(body) do
    path_params = %{
      "path" => Map.merge(%{
        "api_key" => "794190d0-bd7e-11e7-977d-dca90475b70a",
        "response_type" => "application/json",
        "request_type" => "application/json"
       }, body)
    }

    [body: to_string Poison.Encoder.encode(path_params,[])]
  end

end
