# Photo Sharing MVP - Product Plan

## Overview
Event-based photo/video sharing app where guests scan QR codes to instantly upload media. Built with Elixir/Phoenix, optimized for zero-friction guest experience.

## Core User Flows

### Admin/Customer Flow
1. Sign up/login
2. Create event (name, date, optional details)
3. Get unique QR code + shareable link
4. View all uploads for their events

### Guest Flow (Primary - Zero Friction)
1. Scan QR code → lands on event upload page
2. Upload photos/videos (no account needed)
3. See upload progress + success confirmation
4. Browse all event media in gallery

## Technical Architecture

### Storage Options Analysis
| Provider | Cost (1TB storage + 1TB egress) | Pros | Cons |
|----------|----------------------------------|------|------|
| **Cloudflare R2** | ~$15/mo | FREE egress, S3-compatible, fast CDN | Newer service |
| AWS S3 | ~$23 + $90 egress = $113/mo | Battle-tested, ecosystem | Expensive egress |
| Backblaze B2 | ~$6 + $10 egress = $16/mo | Cheapest storage | Slower than CDN |
| Tigris | Free tier → $8/mo | Global edge, S3-compatible | Younger platform |

**Recommendation: Cloudflare R2**
- Free egress = massive savings
- S3-compatible API (use ExAws library)
- Built-in CDN for fast global delivery
- Phoenix + R2 = smooth integration

### Tech Stack
- **Backend**: Phoenix 1.7 + LiveView
- **Database**: PostgreSQL
- **Storage**: Cloudflare R2
- **Upload**: Direct browser → R2 (presigned URLs)
- **Auth**: Phoenix built-in (admin only)
- **QR Codes**: `eqrcode` library

## MVP Features (1 Week Scope)

### Day 1-2: Foundation + Admin Portal
- [ ] Phoenix app setup with Postgres
- [ ] Event schema (id, name, slug, created_at)
- [ ] Admin authentication (email/password)
- [ ] Create/list events page
- [ ] QR code generation (encode event URL)

### Day 3-4: Guest Upload Flow
- [ ] Cloudflare R2 bucket setup
- [ ] Guest landing page (from QR code)
- [ ] Direct upload to R2 with presigned URLs
- [ ] Upload progress UI
- [ ] Media schema (event_id, r2_key, type, uploaded_at)
- [ ] Success confirmation

### Day 5: Gallery Viewing
- [ ] Event gallery page (grid of thumbnails)
- [ ] Lightbox for full-size viewing
- [ ] Video playback
- [ ] Public gallery (accessible via event link)

### Day 6-7: Polish + Deploy
- [ ] Mobile responsive upload page
- [ ] Error handling (file too large, upload failed)
- [ ] Loading states
- [ ] Deploy to Fly.io or Render
- [ ] Testing on real devices

## Database Schema (Minimal)

```elixir
# Events
- id (uuid, pk)
- name (string)
- slug (string, unique) # for QR code URL
- user_id (fk to users)
- inserted_at, updated_at

# Media
- id (uuid, pk)
- event_id (fk to events)
- r2_key (string) # path in R2
- filename (string)
- content_type (string) # image/jpeg, video/mp4
- file_size (integer)
- inserted_at

# Users (Admin)
- id (uuid, pk)
- email (string, unique)
- hashed_password (string)
- inserted_at, updated_at
```

## Key Technical Decisions

### 1. Direct Browser Uploads (Critical for Scale)
- Phoenix generates presigned R2 URLs
- Browser uploads directly to R2 (bypasses server)
- Phoenix only stores metadata
- **Why**: Keeps server costs low, handles concurrent uploads

### 2. No Guest Authentication
- Event slug in URL is the "key"
- Trade-off: Anyone with link can upload
- MVP acceptable; add PIN codes later if needed

### 3. LiveView for Uploads
- Real-time upload progress
- Instant gallery updates
- Minimal JS needed

## Out of Scope (Post-MVP)
- Download all as zip
- Event privacy settings
- Guest names on uploads
- Image moderation
- Analytics/view counts
- Email notifications
- Custom branding per event

## Success Metrics (Post-Launch)
- Upload success rate > 95%
- Page load < 2s on mobile
- Avg time from QR scan → first upload < 30s

## Deployment Considerations
- **Hosting**: Fly.io (Elixir-optimized, free tier available)
- **Domain**: Any (point to Fly app)
- **SSL**: Free via Fly/Cloudflare
- **Backups**: Postgres snapshots + R2 lifecycle policies

## Cost Estimate (First Year)
- Cloudflare R2: $0 (free tier) → ~$15/mo at scale
- Fly.io: $0-20/mo (starter tier)
- **Total**: ~$0-35/mo for MVP

## Next Steps
1. Review and approve plan
2. Set up development environment
3. Create Cloudflare R2 bucket
4. Start Day 1 tasks
