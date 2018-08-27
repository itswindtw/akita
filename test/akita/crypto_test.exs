defmodule Akita.CryptoTest do
  use ExUnit.Case

  alias Akita.Crypto

  setup do
    {:ok,
     key: "12345678901234567890123456789012",
     iv: "1234567890123456",
     encrypted:
       "ff91c8aa01379e4de621a44e5f11f72e4d25bdb1a18242db6cef9ef07d80b0165e476fd1d9acaa53170272c82d122961e1a0700a7427cfa1cf90db7f6d6593bbc93102a4d4b9b66d9974c13c31a7ab4bba1d4e0790f0cbbbd7ad64c6d3c8012a601ceaa808bff70f94a8efa5a4f984b9d41304ffd879612177c622f75f4214fa"}
  end

  test "aes_encrypt/3, aes_decrypt/3", %{key: key, iv: iv, encrypted: encrypted} do
    data =
      URI.encode_query([
        {"MerchantID", 3_430_112},
        {"RespondType", "JSON"},
        {"TimeStamp", 1_485_232_229},
        {"Version", 1.4},
        {"MerchantOrderNo", "S_1485232229"},
        {"Amt", 40},
        {"ItemDesc", "UnitTest"}
      ])

    assert Crypto.aes_encrypt(data, key, iv) == encrypted
    assert Crypto.aes_decrypt(encrypted, key, iv) == data
  end

  test "sha256/3", %{key: key, iv: iv, encrypted: encrypted} do
    assert Crypto.sha256(encrypted, key, iv) ==
             "EA0A6CC37F40C1EA5692E7CBB8AE097653DF3E91365E6A9CD7E91312413C7BB8"
  end
end
