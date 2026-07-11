<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('forest_park_id')->constrained()->onDelete('cascade');
            $table->string('title');
            $table->text('content');
            $table->json('media_urls')->nullable(); // JSON array for post images/videos
            $table->unsignedTinyInteger('rating')->nullable()->default(5); // 1-5 rating scale
            $table->text('tips')->nullable();
            $table->timestamps();
        });

        // Add Full-Text Search Vector column & index for high-performance feed discovery
        DB::statement("ALTER TABLE posts ADD COLUMN search_vector tsvector GENERATED ALWAYS AS (
            to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '') || ' ' || coalesce(tips, ''))
        ) STORED");
        DB::statement('CREATE INDEX posts_search_vector_idx ON posts USING gin (search_vector);');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
