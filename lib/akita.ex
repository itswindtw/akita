defmodule Akita do
  def to_form(%Akita.Request{} = req, key, iv, production_mode \\ true) do
    action =
      if production_mode,
        do: "https://core.spgateway.com/MPG/mpg_gateway",
        else: "https://ccore.spgateway.com/MPG/mpg_gateway"

    trade_info =
      req
      |> Akita.Request.to_map()
      |> URI.encode_query()
      |> Akita.Crypto.aes_encrypt(key, iv)

    trade_sha = Akita.Crypto.sha256(trade_info, key, iv)

    """
    <form id="spgateway" name="spgateway" method="post" action="#{action}">
      <input type="hidden" name="MerchantID" value="#{req.merchant_id}">
      <input type="hidden" name="TradeInfo" value="#{trade_info}">
      <input type="hidden" name="TradeSha" value="#{trade_sha}">
      <input type="hidden" name="Version" value="1.4">
      <input type="submit" value="付款">
    </form>
    """
  end

  def online_response_from_form(form, key, iv) do
    with {:ok, decrypted} <- validate_form(form, key, iv),
         {:ok, map} <- Jason.decode(decrypted) do
      {:ok, Akita.OnlineResponse.from_map(map)}
    end
  end

  def offline_response_from_form(form, key, iv) do
    with {:ok, decrypted} <- validate_form(form, key, iv),
         {:ok, map} <- Jason.decode(decrypted) do
      {:ok, Akita.OfflineResponse.from_map(map)}
    end
  end

  defp validate_form(form, key, iv) do
    trade_info = form["TradeInfo"]
    trade_sha = form["TradeSha"]

    if trade_info && trade_sha && Akita.Crypto.sha256(trade_info, key, iv) == trade_sha do
      {:ok, Akita.Crypto.aes_decrypt(trade_info, key, iv)}
    else
      {:error, :bad_form}
    end
  end
end
