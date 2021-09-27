defmodule TencentCloud.Core do
  @moduledoc """
  Common functions for TencentCloud.
  """

  @doc """
  Gen Common Headers

  ## Examples

      iex> TencentCloud.Core.common_headers(
      ...>   %{
      ...>     host: "nlp.tencentcloudapi.com",
      ...>     action: "ChatBot",
      ...>     version: "2019-04-08",
      ...>     region: "ap-guangzhou",
      ...>     date: "2021-09-27",
      ...>     timestamp: 1632706407,
      ...>     access_key_id: "GebjUWWJJVnL1en1gtgb52CmNJN8CqdKC0ne",
      ...>     access_key_secret: "QtXXc6HftX/LEwrSi+MR4OyVEnEslwyg"
      ...>   },
      ...>   ~s({"Query":"你好，红领巾，我叫白胡子"})
      ...> )
      [
        {"X-TC-Action", "ChatBot"},
        {"X-TC-Region", "ap-guangzhou"},
        {"X-TC-Timestamp", 1632706407},
        {"X-TC-Version", "2019-04-08"},
        {"Authorization", "TC3-HMAC-SHA256 Credential=GebjUWWJJVnL1en1gtgb52CmNJN8CqdKC0ne/2021-09-27/nlp/tc3_request, SignedHeaders=content-type;host, Signature=3ec0d092a50635e6bdfcf051750d55dca5bc39e270348d8e46f928d50d3ed833"},
        {"Content-Type", "application/json; charset=utf-8"},
        {"Host", "nlp.tencentcloudapi.com"}
      ]

  """
  @spec common_headers(common :: map, body :: binary) :: list
  def common_headers(
        %{
          host: host,
          action: action,
          version: version,
          region: region,
          access_key_id: secret_id,
          access_key_secret: secret_key
        } = common,
        body
      ) do
    content_type = Map.get(common, :content_type, "application/json; charset=utf-8")
    timestamp = Map.get_lazy(common, :timestamp, fn -> System.system_time(:second) end)

    date =
      Map.get_lazy(common, :date, fn -> :erlang.date() |> Date.from_erl!() |> Date.to_string() end)

    service = Map.get_lazy(common, :service, fn -> host |> String.split(".") |> hd() end)
    credential_scope = "#{date}/#{service}/tc3_request"

    signature =
      sign(host, body, content_type, timestamp, date, service, credential_scope, secret_key)

    authorization =
      "TC3-HMAC-SHA256 Credential=#{secret_id}/#{credential_scope}, SignedHeaders=content-type;host, Signature=#{signature}"

    [
      {"X-TC-Action", action},
      {"X-TC-Region", region},
      {"X-TC-Timestamp", timestamp},
      {"X-TC-Version", version},
      {"Authorization", authorization},
      {"Content-Type", content_type},
      {"Host", host}
    ]
  end

  def sign(host, body, content_type, timestamp, date, service, credential_scope, secret_key) do
    canonical_request =
      "POST\n/\n\ncontent-type:#{content_type}\nhost:#{host}\n\ncontent-type;host\n#{hash(body)}"

    string_to_sign =
      "TC3-HMAC-SHA256\n#{timestamp}\n#{credential_scope}\n#{hash(canonical_request)}"

    hmac_sha("TC3" <> secret_key, date)
    |> hmac_sha(service)
    |> hmac_sha("tc3_request")
    |> hmac_sha(string_to_sign)
    |> Base.encode16(case: :lower)
  end

  @compile {:inline, hash: 1, hmac_sha: 2}
  defp hash(data), do: :crypto.hash(:sha256, data) |> Base.encode16(case: :lower)
  defp hmac_sha(key, data), do: :crypto.mac(:hmac, :sha256, key, data)
end
