defmodule Akita.Request do
  defstruct merchant_id: nil,
            respond_type: "JSON",
            timestamp: nil,
            version: "1.4",
            lang_type: nil,
            merchant_order_no: nil,
            amt: nil,
            item_desc: nil,
            trade_limit: nil,
            expire_date: nil,
            return_url: nil,
            notify_url: nil,
            customer_url: nil,
            client_back_url: nil,
            email: nil,
            email_modify: nil,
            login_type: 0,
            order_comment: nil,
            credit: nil,
            androidpay: nil,
            samsungpay: nil,
            inst_flag: nil,
            credit_red: nil,
            unionpay: nil,
            webatm: nil,
            vacc: nil,
            cvs: nil,
            barcode: nil,
            p2g: nil,
            cvscom: nil

  # @required_fields [
  #   :merchant_id,
  #   :respond_type,
  #   :timestamp,
  #   :version,
  #   :merchant_order_no,
  #   :amt,
  #   :item_desc,
  #   :email,
  #   :login_type,
  # ]

  @fields %{
    merchant_id: "MerchantID",
    respond_type: "RespondType",
    timestamp: "TimeStamp",
    version: "Version",
    lang_type: "LangType",
    merchant_order_no: "MerchantOrderNo",
    amt: "Amt",
    item_desc: "ItemDesc",
    trade_limit: "TradeLimit",
    expire_date: "ExpireDate",
    return_url: "ReturnURL",
    notify_url: "NotifyURL",
    customer_url: "CustomerURL",
    client_back_url: "ClientBackURL",
    email: "Email",
    email_modify: "EmailModify",
    login_type: "LoginType",
    order_comment: "OrderComment",
    credit: "CREDIT",
    androidpay: "ANDROIDPAY",
    samsungpay: "SAMSUNGPAY",
    inst_flag: "InstFlag",
    credit_red: "CreditRed",
    unionpay: "UNIONPAY",
    webatm: "WEBATM",
    vacc: "VACC",
    cvs: "CVS",
    barcode: "BARCODE",
    p2g: "P2G",
    cvscom: "CVSCOM"
  }

  def to_map(%__MODULE__{} = req) do
    # fill timestamp if not presented
    req = %{req | timestamp: req.timestamp || DateTime.to_unix(DateTime.utc_now())}

    Enum.reduce(Map.to_list(req), %{}, fn {k, v}, acc ->
      case Map.fetch(@fields, k) do
        {:ok, k} ->
          Map.put(acc, k, v)

        :error ->
          acc
      end
    end)
  end
end
