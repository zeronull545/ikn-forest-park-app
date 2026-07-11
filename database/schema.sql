-- Enable PostGIS extension for spatial queries
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. USERS TABLE
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP WITH TIME ZONE NULL,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(255) NULL,
    bio TEXT NULL,
    location GEOGRAPHY(Point, 4326) NULL, -- PostGIS point for live/home location of user
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for spatial queries on users' location
CREATE INDEX idx_users_location ON users USING GIST (location);


-- 2. FOREST PARKS TABLE
CREATE TABLE forest_parks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    location GEOGRAPHY(Point, 4326) NOT NULL, -- Lat/Lng represented as PostGIS Point
    area_hectares NUMERIC(10, 2) NOT NULL,
    facilities JSONB DEFAULT '[]'::jsonb, -- ['camping_ground', 'hiking_track', 'canopy_bridge']
    photos JSONB DEFAULT '[]'::jsonb, -- Array of photo URLs
    opening_hours JSONB DEFAULT '{}'::jsonb, -- e.g. {"monday": "08:00-17:00", ...}
    status VARCHAR(50) DEFAULT 'active', -- active, maintenance, closed
    search_vector TSVECTOR, -- full-text search index cache
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Spatial and standard indexing for forest parks
CREATE INDEX idx_forest_parks_location ON forest_parks USING GIST (location);
CREATE INDEX idx_forest_parks_status ON forest_parks (status);


-- 3. POSTS TABLE
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    park_id INT NULL REFERENCES forest_parks(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    photos JSONB DEFAULT '[]'::jsonb, -- JSON list of posted image URLs
    tags JSONB DEFAULT '[]'::jsonb, -- e.g. ["nature", "travel", "hiking"]
    type VARCHAR(50) DEFAULT 'photo', -- review, tip, photo, news
    search_vector TSVECTOR, -- full-text search index cache
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexing for posts
CREATE INDEX idx_posts_user_id ON posts (user_id);
CREATE INDEX idx_posts_park_id ON posts (park_id);
CREATE INDEX idx_posts_type ON posts (type);


-- 4. COMMENTS TABLE
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    post_id INT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_comments_post_id ON comments (post_id);
CREATE INDEX idx_comments_user_id ON comments (user_id);


-- 5. LIKES TABLE (Polymorphic: post or comment)
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    likeable_id INT NOT NULL,
    likeable_type VARCHAR(100) NOT NULL, -- 'Post' or 'Comment'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_likeable UNIQUE (user_id, likeable_id, likeable_type)
);

CREATE INDEX idx_likes_polymorphic ON likes (likeable_type, likeable_id);


-- 6. PARK VISITS TABLE (User visits check-in & review)
CREATE TABLE park_visits (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    park_id INT NOT NULL REFERENCES forest_parks(id) ON DELETE CASCADE,
    visited_at TIMESTAMP WITH TIME ZONE NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5) NULL,
    notes TEXT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_park_visits_user_park ON park_visits (user_id, park_id);
CREATE INDEX idx_park_visits_visited_at ON park_visits (visited_at);


-- 7. FOLLOWERS TABLE (Social network)
CREATE TABLE followers (
    id SERIAL PRIMARY KEY,
    follower_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_follower_following UNIQUE (follower_id, following_id)
);

CREATE INDEX idx_followers_follower ON followers (follower_id);
CREATE INDEX idx_followers_following ON followers (following_id);


-- 8. NOTIFICATIONS TABLE
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE, -- Target user
    sender_id INT NULL REFERENCES users(id) ON DELETE SET NULL, -- Initiating user
    type VARCHAR(100) NOT NULL, -- follow, like, comment, visit, news_alert
    notifiable_id INT NULL, -- ID of related entity (post_id, comment_id, follower_id)
    notifiable_type VARCHAR(100) NULL,
    data JSONB DEFAULT '{}'::jsonb, -- notification detail body
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user_unread ON notifications (user_id, is_read);


-- 9. FULL-TEXT SEARCH CACHE TRIGGERS & INDEXES (Using Indonesian Configuration where applicable or standard simple)

-- Function to update forest park search vector
CREATE OR REPLACE FUNCTION forest_parks_trigger() RETURNS trigger AS $$
begin
  new.search_vector :=
     setweight(to_tsvector('english', coalesce(new.name,'')), 'A') ||
     setweight(to_tsvector('english', coalesce(new.description,'')), 'B');
  return new;
end
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate_forest_parks BEFORE INSERT OR UPDATE
ON forest_parks FOR EACH ROW EXECUTE FUNCTION forest_parks_trigger();

-- Function to update posts search vector
CREATE OR REPLACE FUNCTION posts_trigger() RETURNS trigger AS $$
begin
  new.search_vector :=
     setweight(to_tsvector('english', coalesce(new.title,'')), 'A') ||
     setweight(to_tsvector('english', coalesce(new.content,'')), 'B');
  return new;
end
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate_posts BEFORE INSERT OR UPDATE
ON posts FOR EACH ROW EXECUTE FUNCTION posts_trigger();

-- Create Indexes for Full-Text Search
CREATE INDEX idx_forest_parks_search_vector ON forest_parks USING GIN (search_vector);
CREATE INDEX idx_posts_search_vector ON posts USING GIN (search_vector);
