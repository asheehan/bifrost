# Bifrost - Photo Sharing MVP Issues

## Day 1-2: Foundation + Admin Portal

### Issue #1: Phoenix App Setup ⏳

**Status**: In Progress
**Priority**: Critical
**Assignee**: Claude

**Tasks**:

- [ ] Initialize Phoenix 1.7 application
- [ ] Configure PostgreSQL database
- [ ] Set up dev environment
- [ ] Verify app runs successfully

**Notes**: Starting from scratch in empty repo.

---

### Issue #2: Event Schema & Context ✅

**Status**: Completed
**Priority**: Critical
**Assignee**: Claude

**Tasks**:

- [x] Generate Event schema with fields: name, slug, user_id
- [x] Add unique index on slug
- [x] Create Events context with CRUD functions
- [x] Add slug generation logic (UUID-based, unique)
- [x] Write tests for Event context

**Notes**: Using UUID for slug (simple and guaranteed unique). Named slugs can be a paid feature later. All 12 tests passing.

---

### Issue #3: Admin Authentication 🔐

**Status**: Not Started
**Priority**: Critical
**Assignee**: Claude

**Tasks**:

- [ ] Run `mix phx.gen.auth Users User users`
- [ ] Update navigation with login/logout
- [ ] Verify registration and login flow
- [ ] Add password reset functionality (comes with phx.gen.auth)

**Notes**: Using Phoenix's official auth generator for security best practices.

---

### Issue #4: Event Management Pages 🎯

**Status**: Not Started
**Priority**: High
**Assignee**: Claude

**Tasks**:

- [ ] Create events index page (list user's events)
- [ ] Create new event form
- [ ] Add event creation logic
- [ ] Display success messages
- [ ] Add basic styling with Phoenix built-in CSS

**Notes**: Admin-only pages, protected by authentication.

---

### Issue #5: QR Code Generation 📱

**Status**: Not Started
**Priority**: High
**Assignee**: Claude

**Tasks**:

- [ ] Add `eqrcode` dependency to mix.exs
- [ ] Create QR code generation function
- [ ] Display QR code on event show page
- [ ] Include event URL in QR code (guest landing page)
- [ ] Add download QR code option

**Notes**: QR code should encode the guest upload URL: `/events/{slug}/upload`

---

## Day 3-4: Guest Upload Flow

### Issue #6: Cloudflare R2 Setup ☁️

**Status**: Not Started
**Priority**: Critical
**Assignee**: User + Claude

**Tasks**:

- [ ] Create Cloudflare R2 bucket
- [ ] Get R2 credentials (access key, secret key)
- [ ] Configure R2 in Phoenix config
- [ ] Add ExAws and ExAws.S3 dependencies
- [ ] Test connection to R2

**Notes**: User needs Cloudflare account. R2 uses S3-compatible API.

---

### Issue #7: Guest Landing Page 🎨

**Status**: Not Started
**Priority**: High
**Assignee**: Claude

**Tasks**:

- [ ] Create guest upload page route (`/events/:slug/upload`)
- [ ] Design mobile-first upload UI
- [ ] Add event name display
- [ ] Show upload instructions
- [ ] Ensure no authentication required

**Notes**: This is the page users land on after scanning QR code. Must be dead simple.

---

### Issue #8: Direct Upload to R2 📤

**Status**: Not Started
**Priority**: Critical
**Assignee**: Claude

**Tasks**:

- [ ] Create presigned URL generation function
- [ ] Add JavaScript for direct browser upload
- [ ] Implement upload progress bar
- [ ] Handle upload success
- [ ] Handle upload errors
- [ ] Save media metadata to database after successful upload

**Notes**: Browser uploads directly to R2, then notifies Phoenix to save metadata.

---

### Issue #9: Media Schema 🗄️

**Status**: Not Started
**Priority**: Critical
**Assignee**: Claude

**Tasks**:

- [ ] Generate Media schema (event_id, r2_key, filename, content_type, file_size)
- [ ] Create Media context
- [ ] Add relationship: Event has_many Media
- [ ] Add function to save media metadata
- [ ] Add indexes on event_id

**Notes**: Only stores metadata; actual files in R2.

---

## Day 5: Gallery Viewing

### Issue #10: Event Gallery Page 🖼️

**Status**: Not Started
**Priority**: High
**Assignee**: Claude

**Tasks**:

- [ ] Create gallery view page (`/events/:slug`)
- [ ] Display media in responsive grid
- [ ] Show thumbnails for images
- [ ] Show video thumbnails with play button
- [ ] Add loading states
- [ ] Make publicly accessible (no auth)

**Notes**: Both admins and guests can view gallery.

---

### Issue #11: Lightbox & Video Playback ▶️

**Status**: Not Started
**Priority**: Medium
**Assignee**: Claude

**Tasks**:

- [ ] Implement lightbox for full-size images
- [ ] Add video player for full-screen playback
- [ ] Add navigation between media items
- [ ] Add close button
- [ ] Ensure mobile responsive

**Notes**: Can use lightweight JS library or build simple modal.

---

## Day 6-7: Polish + Deploy

### Issue #12: Mobile Optimization 📱

**Status**: Not Started
**Priority**: High
**Assignee**: Claude

**Tasks**:

- [ ] Test upload flow on mobile devices
- [ ] Ensure file input works on iOS/Android
- [ ] Optimize image sizes for mobile
- [ ] Test QR code scanning flow
- [ ] Fix any mobile-specific bugs

**Notes**: Primary use case is mobile. Must work flawlessly.

---

### Issue #13: Error Handling & UX Polish ✨

**Status**: Not Started
**Priority**: Medium
**Assignee**: Claude

**Tasks**:

- [ ] Add file size limits (e.g., 100MB)
- [ ] Show clear error messages
- [ ] Add loading states for all actions
- [ ] Improve success confirmations
- [ ] Add helpful text throughout

**Notes**: Make errors actionable and friendly.

---

### Issue #14: Deployment 🚀

**Status**: Not Started
**Priority**: High
**Assignee**: User + Claude

**Tasks**:

- [ ] Set up Fly.io account
- [ ] Configure fly.toml
- [ ] Set up production database
- [ ] Configure environment variables
- [ ] Deploy application
- [ ] Test in production
- [ ] Set up SSL/domain (if needed)

**Notes**: Fly.io has good Phoenix support and free tier.

---

## Completed Issues ✅

_None yet - let's get building!_

---

## Legend

- ⏳ In Progress
- 📋 Not Started
- ✅ Completed
- 🔥 Blocked
- 💡 Needs Discussion
