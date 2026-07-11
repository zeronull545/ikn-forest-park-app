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
        Schema::create('forest_parks', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('description')->nullable();
            $table->string('location_coordinate')->nullable(); // Coordinates as "latitude,longitude"
            $table->decimal('area_hectares', 10, 2)->nullable();
            $table->json('flora_fauna_highlights')->nullable(); // Simple JSON array
            $table->jsonb('facilities_json')->nullable(); // PostgreSQL JSONB column for custom structures
            $table->timestamps();
        });

        // Add GIN index to leverage high-performance PostgreSQL JSONB lookups
        DB::statement('CREATE INDEX forest_parks_facilities_json_gin ON forest_parks USING gin (facilities_json);');

        // Add Full-Text Search Vector column & search index
        DB::statement("ALTER TABLE forest_parks ADD COLUMN search_vector tsvector GENERATED ALWAYS AS (
            to_tsvector('english', coalesce(name, '') || ' ' || coalesce(description, ''))
        ) STORED");
        DB::statement('CREATE INDEX forest_parks_search_vector_idx ON forest_parks USING gin (search_vector);');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('forest_parks');
    }
};
