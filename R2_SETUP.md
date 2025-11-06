# Cloudflare R2 Setup Guide

This guide walks you through setting up Cloudflare R2 for Bifrost photo storage.

## What is R2?

Cloudflare R2 is object storage similar to AWS S3, but with:
- No egress fees (downloading is free)
- S3-compatible API (works with ExAws)
- Generous free tier: 10 GB storage per month

## Step 1: Create a Cloudflare Account

1. Go to https://dash.cloudflare.com/sign-up
2. Create a free account
3. Verify your email

## Step 2: Create an R2 Bucket

1. In the Cloudflare dashboard, click **R2** in the left sidebar
2. Click **Create bucket**
3. Choose a bucket name (e.g., `bifrost-photos` or `your-name-bifrost`)
   - Must be globally unique
   - Lowercase letters, numbers, hyphens only
4. Click **Create bucket**

## Step 3: Get Your Account ID

1. While in the R2 section, look at the URL in your browser
2. It will be something like: `https://dash.cloudflare.com/ACCOUNT_ID/r2`
3. Copy the `ACCOUNT_ID` - you'll need this for configuration

## Step 4: Create API Tokens (Access Keys)

1. In the R2 dashboard, click **Manage R2 API Tokens**
2. Click **Create API token**
3. Give it a name like "Bifrost Upload Token"
4. **Permissions**: Select **Object Read & Write**
5. **TTL**: Leave as default or set to never expire
6. Click **Create API Token**

You'll see:
- **Access Key ID** - Copy this
- **Secret Access Key** - Copy this (you won't see it again!)

**Important**: Save these credentials securely. You won't be able to see the secret key again.

## Step 5: Configure Public Access (Optional but Recommended)

To allow public access to uploaded photos:

1. Go to your bucket settings
2. Click **Settings** tab
3. Under **Public access**, click **Allow Access**
4. You'll get a public URL like: `https://pub-xxxxx.r2.dev`
5. Copy this URL - this is your `R2_PUBLIC_URL`

## Step 6: Set Environment Variables

### For Development (local .env file)

Create a `.env` file in your project root (DO NOT commit this to git!):

```bash
# Cloudflare R2 Configuration
R2_ACCOUNT_ID=your_account_id_here
R2_ACCESS_KEY_ID=your_access_key_id_here
R2_SECRET_ACCESS_KEY=your_secret_access_key_here
R2_BUCKET=your-bucket-name
R2_PUBLIC_URL=https://pub-xxxxx.r2.dev
```

Then load these variables when starting your app:
```bash
export $(cat .env | xargs) && mix phx.server
```

Or use a tool like `direnv` or `dotenv`.

### For Production (Fly.io, Heroku, etc.)

Set these as environment variables in your hosting platform:

**Fly.io**:
```bash
fly secrets set R2_ACCOUNT_ID=your_account_id_here
fly secrets set R2_ACCESS_KEY_ID=your_access_key_id_here
fly secrets set R2_SECRET_ACCESS_KEY=your_secret_access_key_here
fly secrets set R2_BUCKET=your-bucket-name
fly secrets set R2_PUBLIC_URL=https://pub-xxxxx.r2.dev
```

**Heroku**:
```bash
heroku config:set R2_ACCOUNT_ID=your_account_id_here
heroku config:set R2_ACCESS_KEY_ID=your_access_key_id_here
heroku config:set R2_SECRET_ACCESS_KEY=your_secret_access_key_here
heroku config:set R2_BUCKET=your-bucket-name
heroku config:set R2_PUBLIC_URL=https://pub-xxxxx.r2.dev
```

## Step 7: Test the Connection

Start an IEx console:
```bash
iex -S mix
```

Test the connection:
```elixir
Bifrost.Storage.test_connection()
# Should return: :ok
```

If you get an error, check:
1. All environment variables are set correctly
2. Your access keys have the right permissions
3. Your bucket name is correct

## Security Notes

1. **Never commit credentials to git**
   - Add `.env` to your `.gitignore`
   - Use environment variables in production

2. **Use separate tokens for dev/production**
   - Create different API tokens for each environment
   - Makes it easier to rotate credentials

3. **Set appropriate CORS policies**
   - For direct browser uploads, you'll need to configure CORS on your R2 bucket
   - We'll cover this in Issue #8

## Troubleshooting

### "Bucket not configured" error
- Make sure `R2_BUCKET` environment variable is set
- Restart your Phoenix server after setting environment variables

### "Access Denied" error
- Check that your Access Key ID and Secret Access Key are correct
- Verify your API token has "Object Read & Write" permissions
- Make sure the bucket name matches exactly

### "Invalid endpoint" error
- Verify your `R2_ACCOUNT_ID` is correct
- Check that there are no extra spaces in your environment variables

## Cost Estimate

Cloudflare R2 Free Tier (per month):
- 10 GB storage
- 1 million Class A operations (uploads, lists)
- 10 million Class B operations (downloads)

For a small wedding (100 guests, 10 photos each):
- ~5 GB storage (1000 photos × 5 MB each)
- Well within free tier!

Paid pricing if you exceed free tier:
- $0.015 per GB of storage per month
- Very affordable for most use cases

## Next Steps

Once R2 is configured, you can proceed to Issue #8 to implement direct browser uploads!
