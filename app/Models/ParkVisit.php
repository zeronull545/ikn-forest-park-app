<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ParkVisit extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'forest_park_id',
        'visited_at',
        'notes',
    ];

    protected $casts = [
        'visited_at' => 'datetime',
    ];

    /**
     * Get the user who visited the park.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the forest park that was visited.
     */
    public function forestPark(): BelongsTo
    {
        return $this->belongsTo(ForestPark::class);
    }
}
