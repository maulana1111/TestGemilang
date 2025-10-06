@extends('index')

@section('content')
<div class="container mt-5">
    <h2>{{ isset($product) ? 'Edit Produk' : 'Tambah Produk Baru' }}</h2>

    @if ($errors->any())
        <div class="alert alert-danger">
            <strong>Oops!</strong> Ada kesalahan input:<br><br>
            <ul>
                @foreach ($errors->all() as $err)
                    <li>{{ $err }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ isset($product) ? url('/products/'.$product->id) : url('/products') }}" method="POST">
        @csrf
        @if(isset($product))
            @method('PUT')
        @endif

        <div class="mb-3">
            <label for="name" class="form-label">Nama Produk</label>
            <input type="text" name="name" class="form-control" placeholder="Masukkan nama produk"
                   value="{{ old('name', $product->name ?? '') }}">
        </div>

        <div class="mb-3">
            <label for="price" class="form-label">Harga</label>
            <input type="number" name="price" class="form-control" placeholder="Masukkan harga"
                   value="{{ old('price', $product->price ?? '') }}">
        </div>

        <div class="mb-3">
            <label for="stock" class="form-label">Stock</label>
            <input type="number" name="stock" class="form-control" placeholder="Masukkan Stock"
                   value="{{ old('stock', $product->stock ?? '') }}">
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description</label>
            <input type="text" name="description" class="form-control" placeholder="Masukkan Description"
                   value="{{ old('description', $product->description ?? '') }}">
        </div>

        <button type="submit" class="btn btn-primary">
            {{ isset($product) ? 'Update' : 'Simpan' }}
        </button>
        <a href="{{ url('/') }}" class="btn btn-secondary">Batal</a>
    </form>
</div>
@endsection
