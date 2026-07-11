<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StorePostRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        // Relying on Laravel routing 'auth:sanctum' middleware
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'forest_park_id' => 'required|exists:forest_parks,id',
            'title' => 'required|string|min:5|max:255',
            'content' => 'required|string|min:10',
            'media_urls' => 'nullable|array',
            'media_urls.*' => 'required|url',
            'rating' => 'nullable|integer|min:1|max:5',
            'tips' => 'nullable|string|max:1000',
        ];
    }

    /**
     * Custom feedback messages.
     */
    public function messages(): array
    {
        return [
            'forest_park_id.exists' => 'The selected IKN Forest Park does not exist in our system.',
            'rating.min' => 'Rating must be at least 1 star.',
            'rating.max' => 'Rating cannot exceed 5 stars.',
        ];
    }
}
