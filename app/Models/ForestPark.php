<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ForestPark extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'location_coordinate', // Point coordinates (latitude, longitude string)
        'area_hectares',
        'flora_fauna_highlights',
        'facilities_json', // PostgreSQL JSONB column for custom metadata details
    ];

    protected $casts = [
        'area_hectares' => 'decimal:2',
        'flora_fauna_highlights' => 'array',
        'facilities_json' => 'array',
    ];

    /**
     * Get community posts referencing this forest park.
     */
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }

    /**
     * Get user check-ins / visits to this forest park.
     */
    public function visits(): HasMany
    {
        return $this->hasMany(ParkVisit::class);
    }
}
