<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Post;
use App\Http\Requests\StorePostRequest;
use App\Http\Resources\PostResource;
use Illuminate\Http\Request;

class PostController extends Controller
{
    /**
     * Display a listing of posts (Social Feed) with optional searches or park filters.
     */
    public function index(Request $request)
    {
        $query = Post::with(['user', 'forestPark', 'comments.user', 'likes']);

        // Filter feed by specific Forest Park
        if ($request->filled('forest_park_id')) {
            $query->where('forest_park_id', $request->input('forest_park_id'));
        }

        // Full-Text Search on social posts
        if ($request->filled('search')) {
            $searchTerm = $request->input('search');
            $query->whereRaw('search_vector @@ plainto_tsquery(\'english\', ?)', [$searchTerm])
                  ->orderByRaw('ts_rank(search_vector, plainto_tsquery(\'english\', ?)) DESC', [$searchTerm]);
        } else {
            $query->latest();
        }

        $posts = $query->paginate(15);

        return PostResource::collection($posts);
    }

    /**
     * Store a newly created post in database.
     */
    public function store(StorePostRequest $request)
    {
        $validated = $request->validated();
        
        // Inject currently logged-in user
        $validated['user_id'] = $request->user()->id;

        $post = Post::create($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Post shared successfully on the community feed!',
            'data' => new PostResource($post->load(['user', 'forestPark']))
        ], 201);
    }

    /**
     * Display the specified community post.
     */
    public function show($id)
    {
        $post = Post::with(['user', 'forestPark', 'comments.user', 'likes'])->find($id);

        if (!$post) {
            return response()->json([
                'status' => 'error',
                'message' => 'Social post not found'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => new PostResource($post)
        ]);
    }

    /**
     * Update the specified post.
     */
    public function update(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'status' => 'error',
                'message' => 'Post not found'
            ], 404);
        }

        // Authorize action (Owner Only)
        if ($post->user_id !== $request->user()->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'You are not authorized to edit this post'
            ], 403);
        }

        $validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'content' => 'sometimes|required|string',
            'media_urls' => 'nullable|array',
            'media_urls.*' => 'url',
            'rating' => 'sometimes|integer|min:1|max:5',
            'tips' => 'nullable|string',
        ]);

        $post->update($validated);

        return response()->json([
            'status' => 'success',
            'message' => 'Post updated successfully',
            'data' => new PostResource($post->load(['user', 'forestPark']))
        ]);
    }

    /**
     * Remove the specified post from database.
     */
    public function destroy(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'status' => 'error',
                'message' => 'Post not found'
            ], 404);
        }

        // Authorize action (Owner Only)
        if ($post->user_id !== $request->user()->id) {
            return response()->json([
                'status' => 'error',
                'message' => 'You are not authorized to delete this post'
            ], 403);
        }

        $post->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Post deleted successfully'
        ]);
    }
}
