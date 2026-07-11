<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Like;
use App\Models\Post;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    /**
     * Toggle Like/Unlike on a post.
     */
    public function toggle(Request $request, $postId)
    {
        $post = Post::find($postId);

        if (!$post) {
            return response()->json([
                'status' => 'error',
                'message' => 'Post not found'
            ], 404);
        }

        $userId = $request->user()->id;
        $existingLike = Like::where('post_id', $post->id)->where('user_id', $userId)->first();

        if ($existingLike) {
            $existingLike->delete();
            $liked = false;
            $message = 'Post unliked successfully';
        } else {
            Like::create([
                'post_id' => $post->id,
                'user_id' => $userId,
            ]);
            $liked = true;
            $message = 'Post liked successfully';
        }

        $likesCount = Like::where('post_id', $post->id)->count();

        return response()->json([
            'status' => 'success',
            'message' => $message,
            'liked' => $liked,
            'likes_count' => $likesCount,
        ]);
    }
}
