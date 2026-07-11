<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ForestPark;
use App\Models\ParkVisit;
use Illuminate\Http\Request;

class ParkVisitController extends Controller
{
    /**
     * Get visit/check-in history for a specific Forest Park.
     */
    public function index($parkId)
    {
        $park = ForestPark::find($parkId);

        if (!$park) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forest Park not found'
            ], 404);
        }

        $visits = ParkVisit::with('user')
            ->where('forest_park_id', $parkId)
            ->latest('visited_at')
            ->paginate(20);

        return response()->json([
            'status' => 'success',
            'data' => $visits
        ]);
    }

    /**
     * Store a park visit check-in for the authenticated user.
     */
    public function store(Request $request, $parkId)
    {
        $park = ForestPark::find($parkId);

        if (!$park) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forest Park not found'
            ], 404);
        }

        $validated = $request->validate([
            'visited_at' => 'nullable|date|before_or_equal:now',
            'notes' => 'nullable|string|max:500',
        ]);

        $visit = ParkVisit::create([
            'user_id' => $request->user()->id,
            'forest_park_id' => $park->id,
            'visited_at' => $validated['visited_at'] ?? now(),
            'notes' => $validated['notes'] ?? null,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => "Successfully checked into {$park->name}!",
            'data' => $visit->load('user')
        ], 201);
    }
}
