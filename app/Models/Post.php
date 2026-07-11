<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Post extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'forest_park_id',
        'title',
        'content',
        'media_urls', // JSON array of uploaded images or videos
        'rating',
        'tips',
    ];

    protected $casts = [
        'media_urls' => 'array',
        'rating' => 'integer',
    ];

    /**
     * Get the user who shared the post.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the associated forest park of this post.
     */
    public function forestPark(): BelongsTo
    {
        return $this->belongsTo(ForestPark::class);
    }

    /**
     * Get comments on this post.
     */
    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class)->orderBy('created_at', 'asc');
    }

    /**
     * Get likes received by this post.
     */
    public function likes(): HasMany
    {
        return $this->hasMany(Like::class);
    }
}
