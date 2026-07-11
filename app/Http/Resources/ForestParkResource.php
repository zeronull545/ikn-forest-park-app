<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ForestParkResource extends JsonResource
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
            'name' => $this->name,
            'slug' => $this->slug,
            'description' => $this->description,
            'location_coordinate' => $this->location_coordinate,
            'area_hectares' => $this->area_hectares,
            'flora_fauna_highlights' => $this->flora_fauna_highlights ?? [],
            'facilities' => $this->facilities_json ?? [],
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            
            // Loaded relations conditionally to optimize performance
            'visits_count' => $this->whenCounted('visits'),
            'posts_count' => $this->whenCounted('posts'),
            'visits' => $this->whenLoaded('visits'),
            'posts' => PostResource::collection($this->whenLoaded('posts')),
        ];
    }
}
