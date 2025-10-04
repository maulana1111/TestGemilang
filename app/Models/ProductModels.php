<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductModels extends Model
{
    use HasFactory;
    protected $table = 'products';
    protected $fillable = [
        "name",
        "price",
        "stock",
        "description",
        "originator",
    ];
}
