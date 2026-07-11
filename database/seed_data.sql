-- SEED USERS
-- Password matches encrypted version of 'password123'
INSERT INTO users (name, email, email_verified_at, password, avatar, bio, location) VALUES
('Bambang Pamungkas', 'bambang@ikn.go.id', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde', 'Pencinta alam dan penggiat penghijauan di Ibu Kota Nusantara.', ST_SetSRID(ST_MakePoint(116.9856, -0.9619), 4326)),
('Siti Rahma', 'siti.rahma@mail.com', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330', 'Forestry expert based in East Kalimantan. Love hiking and photographing local flora!', ST_SetSRID(ST_MakePoint(116.8312, -1.2421), 4326)),
('Michael Chen', 'm.chen@global.net', NOW(), '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d', 'Expat engineer working in IKN construction. Weekend explorer.', ST_SetSRID(ST_MakePoint(116.9151, -0.9124), 4326));


-- SEED FOREST PARKS
-- All are situated in the real geographic boundaries of East Kalimantan / Ibu Kota Nusantara
INSERT INTO forest_parks (name, slug, description, location, area_hectares, facilities, photos, opening_hours, status) VALUES
(
  'Taman Hutan Raya Bukit Soeharto',
  'taman-hutan-raya-bukit-soeharto',
  'Kawasan pelestarian alam yang luas di Kalimantan Timur, berfungsi sebagai paru-paru utama penyangga Ibu Kota Nusantara (IKN). Menyediakan ekosistem hutan hujan tropis yang kaya akan flora endemik Kalimantan seperti Meranti dan Ulin, serta fauna langka seperti Orangutan dan Beruang Madu.',
  ST_SetSRID(ST_MakePoint(116.9934, -1.0256), 4326),
  61850.00,
  '["Camping Ground", "Research Center", "Forest Canopy Trail", "Parking Area", "Public Restrooms"]'::jsonb,
  '["https://images.unsplash.com/photo-1502082553048-f009c37129b9", "https://images.unsplash.com/photo-1448375240586-882707db888b"]'::jsonb,
  '{"weekday": "08:00 - 17:00", "weekend": "07:00 - 18:00"}'::jsonb,
  'active'
),
(
  'Hutan Lindung IKN (Sungai Wain)',
  'hutan-lindung-ikn-sungai-wain',
  'Hutan primer yang terlindungi dengan keanekaragaman hayati luar biasa tinggi. Menjadi habitat alami bagi Orangutan Kalimantan, Beruang Madu, dan tumbuhan kantong semar (Nepenthes). Merupakan sumber tangkapan air utama untuk wilayah Balikpapan dan koridor IKN.',
  ST_SetSRID(ST_MakePoint(116.8333, -1.1333), 4326),
  9782.00,
  '["Guiding Center", "Suspension Bridge", "Bird Watching Tower", "Educational Center"]'::jsonb,
  '["https://images.unsplash.com/photo-1511497584788-876760111969", "https://images.unsplash.com/photo-1513836279014-a89f7a76ae86"]'::jsonb,
  '{"weekday": "07:30 - 16:30", "weekend": "07:30 - 16:30"}'::jsonb,
  'active'
),
(
  'Taman Kota Nusantara',
  'taman-kota-nusantara',
  'Taman kota modern berkonsep "Forest City" di pusat pemerintahan IKN. Menggabungkan arsitektur ramah lingkungan, ruang hijau terbuka, jogging track, dan danau retensi buatan untuk rekreasi warga urban IKN.',
  ST_SetSRID(ST_MakePoint(116.9125, -0.9234), 4326),
  45.50,
  '["Jogging Track", "Amphitheater", "Bicycle Rental", "WiFi Zone", "Food Court", "Kids Playground"]'::jsonb,
  '["https://images.unsplash.com/photo-1441974231531-c6227db76b6e", "https://images.unsplash.com/photo-1473448912268-2022ce9509d8"]'::jsonb,
  '{"weekday": "06:00 - 22:00", "weekend": "05:00 - 23:00"}'::jsonb,
  'active'
);


-- SEED POSTS
INSERT INTO posts (user_id, park_id, title, content, photos, tags, type) VALUES
(
  1,
  1,
  'Udara Pagi yang Luar Biasa di Bukit Soeharto!',
  'Tadi pagi menyempatkan diri bersepeda ke kawasan Tahura Bukit Soeharto. Udaranya sangat segar, khas hutan hujan Kalimantan yang masih terjaga. Sangat senang melihat bagian ini mendapat proteksi penuh dalam masterplan IKN.',
  '["https://images.unsplash.com/photo-1473448912268-2022ce9509d8"]'::jsonb,
  '["bukitsoeharto", "pesona_ikn", "cycling", "morningvibes"]'::jsonb,
  'review'
),
(
  2,
  2,
  'Menemukan Kantong Semar Endemik di Sungai Wain',
  'Dalam ekspedisi botani hari ini di Hutan Lindung Sungai Wain, kami mendokumentasikan beberapa spesimen Nepenthes ampullaria yang sangat sehat. Hutan primer ini wajib kita jaga agar kelestarian flora unik Kalimantan tetap lestari.',
  '["https://images.unsplash.com/photo-1513836279014-a89f7a76ae86"]'::jsonb,
  '["flora", "botany", "sungaiwain", "biodiversity"]'::jsonb,
  'photo'
),
(
  3,
  3,
  'Perfect spot for jogging after work in Central IKN',
  'Taman Kota Nusantara is highly recommended. World-class infrastructure merged beautifully with high trees. The air is surprisingly clean even during high-density city construction nearby. Love this place!',
  '["https://images.unsplash.com/photo-1441974231531-c6227db76b6e"]'::jsonb,
  '["ikn_city", "forestrun", "expat_life", "greenery"]'::jsonb,
  'tip'
);


-- SEED COMMENTS
INSERT INTO comments (user_id, post_id, content) VALUES
(2, 1, 'Mantap sekali Pak Bambang! Semoga jalur sepedanya terus diperluas dengan konsep ecotourism.'),
(1, 2, 'Luar biasa dokumentasinya Bu Siti! Bisakah umum ikut serta dalam kunjungan penelitian kesana?'),
(2, 3, 'Glad you enjoy it, Michael! Feel free to join our weekend runner community there sometime!');


-- SEED LIKES
-- Bambang likes Siti''s post
INSERT INTO likes (user_id, likeable_id, likeable_type) VALUES
(1, 2, 'Post'),
-- Michael likes Bambang''s post
(3, 1, 'Post'),
-- Siti likes Bambang''s reply comment
(2, 2, 'Comment');


-- SEED PARK VISITS
INSERT INTO park_visits (user_id, park_id, visited_at, rating, notes) VALUES
(1, 1, NOW() - INTERVAL '1 DAY', 5, 'Riding bicycle inside Tahura buffer zone.'),
(2, 2, NOW() - INTERVAL '2 DAY', 5, 'Conducting ecological survey in Sungai Wain block B.'),
(3, 3, NOW(), 4, 'Evening walk after project meeting in Government core area.');


-- SEED FOLLOWERS
INSERT INTO followers (follower_id, following_id) VALUES
(1, 2), -- Bambang follows Siti
(2, 1), -- Siti follows Bambang
(3, 2); -- Michael follows Siti


-- SEED NOTIFICATIONS
INSERT INTO notifications (user_id, sender_id, type, notifiable_id, notifiable_type, data, is_read) VALUES
(2, 1, 'follow', 1, 'User', '{"message": "Bambang Pamungkas started following you"}'::jsonb, false),
(2, 1, 'comment', 2, 'Post', '{"message": "Bambang Pamungkas commented on your post: Luar biasa dokumentasinya..."}'::jsonb, false),
(3, 2, 'comment', 3, 'Post', '{"message": "Siti Rahma commented on your post: Glad you enjoy it, Michael..."}'::jsonb, true);
