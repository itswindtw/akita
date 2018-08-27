defmodule Akita.Crypto do
  def aes_encrypt(data, key, iv) do
    :crypto.block_encrypt(:aes_cbc256, key, iv, pad(data))
    |> Base.encode16(case: :lower)
  end

  def aes_decrypt(data, key, iv) do
    case Base.decode16(data, case: :lower) do
      {:ok, decoded} ->
        case :crypto.block_decrypt(:aes_cbc256, key, iv, decoded) do
          :error ->
            :error

          decrypted ->
            unpad(decrypted)
        end

      :error ->
        :error
    end
  end

  def sha256(data, key, iv) do
    :crypto.hash(:sha256, "HashKey=#{key}&#{data}&HashIV=#{iv}")
    |> Base.encode16()
  end

  def pad(data, block_size \\ 32) do
    to_pad = block_size - rem(byte_size(data), block_size)

    data <> :binary.copy(<<to_pad>>, to_pad)
  end

  def unpad(data) do
    to_unpad = :binary.last(data)
    :binary.part(data, {0, byte_size(data) - to_unpad})
  end
end
