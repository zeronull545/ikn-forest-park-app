<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\ForestPark;
use App\Http\Resources\ForestParkResource;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ForestParkController extends Controller
{
    /**
     * Display a listing of forest parks with support for search & JSONB filters.
     */
    public function index(Request $request)
    {
        $query = ForestPark::query();

        // 1. PostgreSQL Full-Text Search implementation
        if ($request->filled('search')) {
            $searchTerm = $request->input('search');
            // Format terms for plainto_tsquery or to_tsquery
            $query->whereRaw('search_vector @@ plainto_tsquery(\'english\', ?)', [$searchTerm])
                  ->orderByRaw('ts_rank(search_vector, plainto_tsquery(\'english\', ?)) DESC', [$searchTerm]);
        }

        // 2. Minimum Area Size filter
        if ($request->filled('min_area')) {
            $query->where('area_hectares', '>=', $request->input('min_area'));
        }

        // 3. PostgreSQL JSONB query filters for facilities
        if ($request->boolean('hiking_only')) {
            $query->where('facilities_json->hiking_trails', true);
        }

        if ($request->boolean('canopy_only')) {
            $query->where('facilities_json->canopy_walk', true);
        }

        if ($request->boolean('free_only')) {
            $query->where('facilities_json->entry_fee_idr', 0);
        }

        $parks = $query->latest('id')->paginate(15);

        return ForestParkResource::collection($parks);
    }

    /**
     * Store a newly created forest park in database.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:forest_parks,name',
            'description' => 'required|string',
            'location_coordinate' => 'nullable|string|regex:/^[-]?\d+(\.\d+)?,[-]?\d+(\.\d+)?$/', // lat,lng format
            'area_hectares' => 'nullable|numeric|min:0',
            'flora_fauna_highlights' => 'nullable|array',
            'flora_fauna_highlights.*' => 'string',
            'facilities_json' => 'nullable|array',
        ]);

        $validated['slug'] = Str::slug($validated['name']);

        $park = ForestPark::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Forest Park created successfully',
            'data' => new ForestParkResource($park)
        ], 201);
    }

    /**
     * Display the specified forest park with detail structures.
     */
    public function show($id)
    {
        $park = ForestPark::with(['visits.user', 'posts.user'])->find($id);

        if (!$park) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forest Park not found'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => new ForestParkResource($park)
        ]);
    }

    /**
     * Update the specified forest park in database.
     */
    public function update(Request $request, $id)
    {
        $park = ForestPark::find($id);

        if (!$park) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forest Park not found'
            ], 404);
        }

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255|unique:forest_parks,name,' . $park->id,
            'description' => 'sometimes|required|string',
            'location_coordinate' => 'nullable|string|regex:/^[-]?\d+(\.\d+)?,[-]?\d+(\.\d+)?$/',
            'area_hectares' => 'nullable|numeric|min:0',
            'flora_fauna_highlights' => 'nullable|array',
            'flora_fauna_highlights.*' => 'string',
            'facilities_json' => 'nullable|array',
        ]);

        if (isset($validated['name'])) {
            $validated['slug'] = Str::slug($validated['name']);
        }

        $park->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Forest Park updated successfully',
            'data' => new ForestParkResource($park)
        ]);
    }

    /**
     * Remove the specified forest park from database.
     */
    public function destroy($id)
    {
        $park = ForestPark::find($id);

        if (!$park) {
            return response()->json([
                'status' => 'error',
                'message' => 'Forest Park not found'
            ], 404);
        }

        $park->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Forest Park removed successfully'
        ]);
    }
}
