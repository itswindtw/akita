defmodule Akita.OfflineResponse do
  defstruct [:status, :message, :result]

  def from_map(map) do
    %__MODULE__{
      status: map["Status"],
      message: map["Message"],
      result: __MODULE__.Result.from_map(map["Result"])
    }
  end
end

defmodule Akita.OfflineResponse.Result do
  defstruct [
    :merchant_id,
    :amt,
    :trade_no,
    :merchant_order_no,
    :payment_type,
    :expire_date,

    # VACC
    :bank_code,
    :code_no,

    # VACC
    :code_no,

    # BARCODE
    :barcode_1,
    :barcode_2,
    :barcode_3,

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
      expire_date: map["ExpireDate"] && parse_date(map["ExpireDate"])
    }

    case result.payment_type do
      "VACC" ->
        %__MODULE__{
          result
          | bank_code: map["BankCode"],
            code_no: map["CodeNo"]
        }

      "CVS" ->
        %__MODULE__{
          result
          | code_no: map["CodeNo"]
        }

      "BARCODE" ->
        %__MODULE__{
          result
          | barcode_1: map["Barcode_1"],
            barcode_2: map["Barcode_2"],
            barcode_3: map["Barcode_3"]
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

  defp parse_date(str) do
    case Date.from_iso8601(str) do
      {:ok, date} ->
        date

      _ ->
        str
    end
  end
end
