defmodule Bifrost.Storage do
  @moduledoc """
  Handles file storage operations with Cloudflare R2.

  R2 uses the S3-compatible API via ExAws.
  """

  @doc """
  Uploads a file to R2.

  ## Parameters
  - `file_path` - Local path to the file to upload
  - `key` - The key (path) where the file should be stored in R2
  - `opts` - Additional options like content_type

  ## Examples

      iex> Bifrost.Storage.upload("/tmp/photo.jpg", "events/abc123/photo.jpg", content_type: "image/jpeg")
      {:ok, "https://..."}

      iex> Bifrost.Storage.upload("/tmp/invalid.jpg", "test.jpg")
      {:error, reason}
  """
  def upload(file_path, key, opts \\ []) do
    bucket = get_bucket()
    content_type = Keyword.get(opts, :content_type, "application/octet-stream")

    file_path
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(bucket, key, content_type: content_type)
    |> ExAws.request()
    |> case do
      {:ok, _response} ->
        {:ok, public_url(key)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Generates a presigned URL for direct browser upload to R2.

  This allows browsers to upload files directly to R2 without going through
  the Phoenix server.

  ## Parameters
  - `key` - The key (path) where the file will be stored
  - `opts` - Options including:
    - `:expires_in` - Seconds until the URL expires (default: 3600)
    - `:content_type` - Content type for the upload

  ## Examples

      iex> Bifrost.Storage.presigned_upload_url("events/abc/photo.jpg", expires_in: 300)
      {:ok, "https://...?signature=..."}
  """
  def presigned_upload_url(key, opts \\ []) do
    bucket = get_bucket()
    expires_in = Keyword.get(opts, :expires_in, 3600)
    content_type = Keyword.get(opts, :content_type)

    config = ExAws.Config.new(:s3)

    options = [expires_in: expires_in]
    options = if content_type, do: [{:content_type, content_type} | options], else: options

    {:ok, presigned_url} = ExAws.S3.presigned_url(config, :put, bucket, key, options)
    {:ok, presigned_url}
  rescue
    error -> {:error, error}
  end

  @doc """
  Deletes a file from R2.

  ## Examples

      iex> Bifrost.Storage.delete("events/abc123/photo.jpg")
      :ok
  """
  def delete(key) do
    bucket = get_bucket()

    bucket
    |> ExAws.S3.delete_object(key)
    |> ExAws.request()
    |> case do
      {:ok, _response} -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Gets the public URL for a file in R2.

  ## Examples

      iex> Bifrost.Storage.public_url("events/abc123/photo.jpg")
      "https://pub-xxxxx.r2.dev/events/abc123/photo.jpg"
  """
  def public_url(key) do
    base_url = Application.get_env(:bifrost, :r2)[:public_url]

    if base_url do
      "#{base_url}/#{key}"
    else
      # Fallback if public URL not configured
      bucket = get_bucket()
      account_id = System.get_env("R2_ACCOUNT_ID")
      "https://#{account_id}.r2.cloudflarestorage.com/#{bucket}/#{key}"
    end
  end

  @doc """
  Lists objects in a specific prefix (folder).

  ## Examples

      iex> Bifrost.Storage.list_objects("events/abc123/")
      {:ok, ["events/abc123/photo1.jpg", "events/abc123/photo2.jpg"]}
  """
  def list_objects(prefix) do
    bucket = get_bucket()

    bucket
    |> ExAws.S3.list_objects(prefix: prefix)
    |> ExAws.request()
    |> case do
      {:ok, %{body: %{contents: objects}}} ->
        keys = Enum.map(objects, & &1.key)
        {:ok, keys}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Checks if R2 is configured and accessible.

  Returns :ok if configuration is present, {:error, reason} otherwise.
  """
  def test_connection do
    bucket = get_bucket()

    if bucket do
      # Try to list objects in the bucket (without prefix lists all)
      bucket
      |> ExAws.S3.list_objects(max_keys: 1)
      |> ExAws.request()
      |> case do
        {:ok, _} -> :ok
        {:error, reason} -> {:error, reason}
      end
    else
      {:error, "R2 bucket not configured. Set R2_BUCKET environment variable."}
    end
  end

  defp get_bucket do
    Application.get_env(:bifrost, :r2)[:bucket] || System.get_env("R2_BUCKET")
  end
end
