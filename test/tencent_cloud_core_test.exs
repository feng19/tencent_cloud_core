defmodule TencentCloud.CoreTest do
  use ExUnit.Case
  doctest TencentCloud.Core

  test "sign" do
    host = "nlp.tencentcloudapi.com"
    body = ~s({"Query":"你好，红领巾，我叫白胡子"})
    content_type = "application/json; charset=utf-8"
    timestamp = 1_632_706_407
    date = "2021-09-27"
    service = "nlp"
    credential_scope = "#{date}/#{service}/tc3_request"
    secret_key = "QtXXc6HftX/LEwrSi+MR4OyVEnEslwyg"

    assert TencentCloud.Core.sign(
             host,
             body,
             content_type,
             timestamp,
             date,
             service,
             credential_scope,
             secret_key
           ) == "3ec0d092a50635e6bdfcf051750d55dca5bc39e270348d8e46f928d50d3ed833"
  end
end
