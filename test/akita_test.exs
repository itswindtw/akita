defmodule AkitaTest do
  use ExUnit.Case

  setup do
    {:ok, key: "ni87APTA0GoSYAZkfdCbkBwnb7wAdMR3", iv: "UhKpzRHYILdDAKVm"}
  end

  @tag :interactive
  test "to_form/4", %{key: key, iv: iv} do
    random_merchant_order_no =
      Enum.into(1..20, [], fn _ ->
        Enum.random('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
      end)
      |> to_string()

    req = %Akita.Request{
      merchant_id: "MS14612657",
      merchant_order_no: random_merchant_order_no,
      amt: 100,
      item_desc: random_merchant_order_no,
      email: "akita@example.com",
      notify_url: "https://akita.free.beeceptor.com/notify_callback"
    }

    IO.puts(Akita.to_form(req, key, iv, false))
  end

  test "online_response_from_form/3 (SUCCESS)", %{key: key, iv: iv} do
    form = %{
      "Status" => "SUCCESS",
      "MerchantID" => "MS14612657",
      "TradeInfo" =>
        "9413a4b845f474efd5004a54778487c057309ccb4707ccb3e1d5fdb4e490774b09b0c5cc4b085e153b1f3d451465fe390b49d6cd55cc541f8a24b1819a9ec5d4df31ae0568b8cd4eb655f3cb4ac0ae6ebb9f76a79e1759bdf3f0b2008f32641df5f42fcf706cc86a0addd05c7830c136f75ac6413c5f31429d63489d0395af69dc505396528ccd97f2521000bd4d20d314567b1d9691f7f19648a0ad3b7633abbb397896cbea42bf394a8e77488619381c128955cc6bb440b5ff00bd54a39a05a10b49c1f3ecf7af022995dbc29a715bd5cd94be4c2700fcec2865d6d6e0066bc9ba758253a43a24b9a5dba1d4a9fd4f4fdc3339be0e83ce6f7cf15950cc2e8fe73c93035210bbec82d6d8b511f83797bac8c837eeb713cc974ed75940713f2c7c20c1e1910d413f75a93863a66a023541123ff2ee29cccc043e6e3d2ed446a273632561780425c65f1f4b6b5d20ff2631f991c579b3269c3a492d102ed74b0ddc43d0164ad46862320dc1cda27facd197961be01f23fd431b4cb597c664409f8fe8bb00446c985cf321c03e9d1b99a9aa194df4a66823b24da91933deda72be51e32ac90f016005f8b9989a0d0b445d24ed0b01b9dd4a0e1c2c83bcec852c2b5d4de41d3952bcc488c12fb9b528896d75a043a76bf6789f216aefe23c4876f2",
      "TradeSha" => "C4BDC330798C7DA3B8FC637D9D3A4612D4FF4B268CB0983DCC3A59EC659AB750",
      "Version" => 1.4
    }

    {:ok, resp} = Akita.online_response_from_form(form, key, iv)

    assert resp.result.merchant_id == "MS14612657"
    assert resp.result.amt == 100
    assert resp.result.trade_no == "18082222410208459"
    assert resp.result.merchant_order_no == "G3SL7YZJ3XW6YCD5OQ13"
    assert resp.result.payment_type == "CREDIT"
    assert resp.result.respond_type == "JSON"

    pay_time =
      DateTime.from_naive!(NaiveDateTime.from_erl!({{2018, 8, 22}, {14, 41, 2}}), "Etc/UTC")

    assert DateTime.compare(resp.result.pay_time, pay_time) == :eq
    assert resp.result.ip == "1.161.11.83"
  end
end
