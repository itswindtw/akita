# Akita

A spgateway package for elixir. Based on MPG_1.1.1.

## Installation

1. add `akita` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:akita, git: "https://github.com/itswindtw/akita.git"},
  ]
end
```

2. fill `Akita.Request` struct and use `Akita.to_form/4` generate html code:

```elixir
req =
  %Akita.Request{
    merchant_id: "Merchant Id",
    merchant_order_no: "Merchant Order No",
    amt: amount,
    item_desc: "Item description",
    email: "email",
    ..
  }

form = Akita.to_form(req, config[:key], config[:iv], config[:production_mode] \\ true)

html(conn, "#{form}<script>document.forms['spgateway'].submit()</script>")
```

3. parse callback using `Akita.offline_response_from_form/3` or `Akita.online_response_from_form/3`

```elixir
{:ok, resp} = Akita.online_response_from_form(params, config[:key], config[:iv])

resp = %Akita.OnlineResponse{
  status: "SUCCESS",
  message: "授權成功"
  result: %Akita.OnlineResponse.Result{
    TradeNo: "18082222410208459",
    ..
  }
}
```
