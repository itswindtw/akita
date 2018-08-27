defmodule Akita.OnlineResponse do
  defstruct [:status, :message, :result]

  def from_map(map) do
    %__MODULE__{
      status: map["Status"],
      message: map["Message"],
      result: __MODULE__.Result.from_map(map["Result"])
    }
  end
end

defmodule Akita.OnlineResponse.Result do
  defstruct [
    :merchant_id,
    :amt,
    :trade_no,
    :merchant_order_no,
    :payment_type,
    :respond_type,
    :pay_time,
    :ip,
    :escrow_bank,

    # Credit, GooglePay, SamsungPay
    :respond_code,
    :auth,
    :card_6_no,
    :card_4_no,
    :inst,
    :inst_first,
    :inst_each,
    :eci,
    :token_use_status,
    :red_amt,
    :payment_method,

    # WEBATM, VACC
    :pay_bank_code,
    :payer_account_5_code,

    # CVS
    :code_no,
    :store_type,
    :store_id,

    # BARCODE
    :barcode_1,
    :barcode_2,
    :barcode_3,
    :pay_store,

    # P2G
    :p2g_trade_no,
    :p2g_payment_type,
    :p2g_amt,

    # CVSCOM
    :store_code,
    :store_name,
    :store_type,
    :store_addr,
    :trade_type,
    :cvscom_name,
    :cvscom_phone
  ]

  def from_map(map) do
    result = %__MODULE__{
      merchant_id: map["MerchantID"],
      amt: map["Amt"],
      trade_no: map["TradeNo"],
      merchant_order_no: map["MerchantOrderNo"],
      payment_type: map["PaymentType"],
      respond_type: map["RespondType"],
      pay_time: map["PayTime"] && parse_datetime(map["PayTime"]),
      ip: map["IP"],
      escrow_bank: map["EscrowBank"]
    }

    case result.payment_type do
      x when x in ["CREDIT", "ANDROIDPAY", "SAMSUNGPAY"] ->
        %__MODULE__{
          result
          | respond_code: map["RespondCode"],
            auth: map["Auth"],
            card_6_no: map["Card6No"],
            card_4_no: map["Card4No"],
            inst: map["Inst"],
            inst_first: map["InstFirst"],
            inst_each: map["InstEach"],
            eci: map["ECI"],
            token_use_status: map["TokenUseStatus"],
            red_amt: map["RedAmt"],
            payment_method: map["PaymentMethod"]
        }

      x when x in ["WEBATM", "VACC"] ->
        %__MODULE__{
          result
          | pay_bank_code: map["PayBankCode"],
            payer_account_5_code: map["PayerAccount5Code"]
        }

      "CVS" ->
        %__MODULE__{
          result
          | code_no: map["CodeNo"],
            store_type: map["StoreType"],
            store_id: map["StoreID"]
        }

      "BARCODE" ->
        %__MODULE__{
          result
          | barcode_1: map["Barcode_1"],
            barcode_2: map["Barcode_2"],
            barcode_3: map["Barcode_3"],
            pay_store: map["PayStore"]
        }

      "P2G" ->
        %__MODULE__{
          result
          | p2g_trade_no: map["P2GTradeNo"],
            p2g_payment_type: map["P2GPaymentType"],
            p2g_amt: map["P2GAmt"]
        }

      "CVSCOM" ->
        %__MODULE__{
          result
          | store_code: map["StoreCode"],
            store_name: map["StoreName"],
            store_type: map["StoreType"],
            store_addr: map["StoreAddr"],
            trade_type: map["TradeType"],
            cvscom_name: map["CVSCOMName"],
            cvscom_phone: map["CVSCOMPhone"]
        }

      _ ->
        result
    end
  end

  def parse_datetime(str) do
    case DateTime.from_iso8601("#{str}+08") do
      {:ok, datetime, _} ->
        datetime

      {:error, _} ->
        str
    end
  end
end
