<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Request;
use App\Models\ProductModels;

class ProductController extends Controller
{
    public function index()
    {
        $products = ProductModels::paginate(5);

        return view('product.index', compact("products"));
    }

    public function create()
    {
        return view('product.form');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name'  => 'required|string|max:255',
            'price' => 'required|integer|min:0',
            'stock' => 'required|integer',
            'description'  => 'required|string|max:500',
        ]);

        ProductModels::create([
            'name' => $request->name,
            'price' => $request->price,
            'stock' => $request->stock,
            'description' => $request->description,
            'originator' => 'INTERNAL',
        ]);
        
        return redirect('/')->with('success', 'Produk berhasil ditambahkan!');
    }

    public function edit($id)
    {
        $product = ProductModels::findOrFail($id);

        return view('product.form', compact('product'));
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'name'  => 'required|string|max:255',
            'price' => 'required|integer|min:0',
            'stock' => 'required|integer',
            'description'  => 'required|string|max:500',
        ]);

        $product = ProductModels::findOrFail($id);
        $product->update($request->all());

        return redirect('/')->with('success', 'Produk berhasil diupdate');
    }

    public function destroy($id)
    {
        $product = ProductModels::findOrFail($id);
        $product->delete();

        return redirect('/')->with('success', 'Produk berhasil dihapus');
    }

    public function sync()
    {
        $response = Http::get('https://fakestoreapi.com/products'); 
        $data = $response->json();

        if (!$data) {
            return redirect('/')->with('error', 'Gagal mengambil data dari API');
        }

        foreach ($data as $item) {
            ProductModels::updateOrCreate(
                [                    
                    'name'        => $item['title'],
                ],
                [
                    'price'       => $item['price'],
                    'stock'       => $item['stock'] ?? 0,
                    'description' => $item['description'] ?? null,
                    'originator'  => "EXTERNAL",
                ]
            );
        }

        return redirect('/')->with('success', 'Data berhasil disinkronkan dari API');
    }

    public function getProducts()
    {
        $products = ProductModels::all();

        // return response()->json([
        //     'success' => true,
        //     'message' => 'List data produk',
        //     'data'    => $products
        // ]);
        
        return response()->json($products);
    }
}
