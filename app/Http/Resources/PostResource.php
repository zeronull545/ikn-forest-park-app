<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'content' => $this->content,
            'media_urls' => $this->media_urls ?? [],
            'rating' => $this->rating,
            'tips' => $this->tips,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            
            // Core Relationships
            'user' => $this->whenLoaded('user', function () {
                return [
                    'id' => $this->user->id,
                    'name' => $this->user->name,
                    'avatar_url' => $this->user->avatar_url,
                ];
            }),
            'forest_park' => $this->whenLoaded('forestPark', function () {
                return [
                    'id' => $this->forestPark->id,
                    'name' => $this->forestPark->name,
                    'slug' => $this->forestPark->slug,
                ];
            }),
            'comments' => $this->whenLoaded('comments', function () {
                return $this->comments->map(function ($comment) {
                    return [
                        'id' => $comment->id,
                        'content' => $comment->content,
                        'created_at' => $comment->created_at,
                        'user' => [
                            'id' => $comment->user->id,
                            'name' => $comment->user->name,
                            'avatar_url' => $comment->user->avatar_url,
                        ]
                    ];
                });
            }),
            'likes_count' => $this->relationLoaded('likes') ? $this->likes->count() : 0,
            'liked_by_me' => $request->user() && $this->relationLoaded('likes') 
                ? $this->likes->pluck('user_id')->contains($request->user()->id) 
                : false,
        ];
    }
}
