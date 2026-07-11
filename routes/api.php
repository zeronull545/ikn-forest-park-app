<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ForestParkController;
use App\Http\Controllers\API\PostController;
use App\Http\Controllers\API\CommentController;
use App\Http\Controllers\API\LikeController;
use App\Http\Controllers\API\ParkVisitController;

/*
|--------------------------------------------------------------------------
| API Routes - IKN Forest Parks Social App
|--------------------------------------------------------------------------
*/

// Public Auth Routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

// Public Read-Only Routes
Route::get('/parks', [ForestParkController::class, 'index']);
Route::get('/parks/{id}', [ForestParkController::class, 'show']);
Route::get('/parks/{parkId}/visits', [ParkVisitController::class, 'index']);

Route::get('/posts', [PostController::class, 'index']);
Route::get('/posts/{id}', [PostController::class, 'show']);

// Authenticated Routes
Route::middleware('auth:sanctum')->group(function () {
    // Current User Profile & Sign-out
    Route::get('/auth/me', [AuthController::class, 'me']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Forest Parks Administration / Moderation
    Route::post('/parks', [ForestParkController::class, 'store']);
    Route::put('/parks/{id}', [ForestParkController::class, 'update']);
    Route::delete('/parks/{id}', [ForestParkController::class, 'destroy']);

    // Posts / Feeds Management
    Route::post('/posts', [PostController::class, 'store']);
    Route::put('/posts/{id}', [PostController::class, 'update']);
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);

    // Comments Management
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);

    // Likes Toggle Route
    Route::post('/posts/{postId}/like', [LikeController::class, 'toggle']);

    // Park Checkins / Visits
    Route::post('/parks/{parkId}/visit', [ParkVisitController::class, 'store']);
});
