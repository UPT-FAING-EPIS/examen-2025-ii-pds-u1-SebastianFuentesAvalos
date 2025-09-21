<template>
  <div class="products-view">
    <h2>Catálogo de Productos</h2>
    
    <div class="filters">
      <input v-model="searchTerm" placeholder="Buscar productos..." class="search-input" />
    </div>

    <div class="products-grid">
      <div v-for="product in filteredProducts" :key="product.id" class="product-card">
        <img :src="product.imageUrl" :alt="product.name" class="product-image" />
        <div class="product-info">
          <h3>{{ product.name }}</h3>
          <p class="product-description">{{ product.description }}</p>
          <p class="product-price">${{ product.price }}</p>
          <p class="product-stock">Stock: {{ product.stock }}</p>
          <button @click="addToCart(product)" class="add-to-cart-btn">
            Agregar al Carrito
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

interface Product {
  id: number
  name: string
  description: string
  price: number
  stock: number
  categoryId: number
  imageUrl: string
  available: boolean
}

const products = ref<Product[]>([])
const searchTerm = ref('')

const filteredProducts = computed(() => {
  if (!searchTerm.value) return products.value
  return products.value.filter(p => 
    p.name.toLowerCase().includes(searchTerm.value.toLowerCase())
  )
})

const loadProducts = async () => {
  try {
    // Conectar con la API real del backend
    const response = await fetch('https://sebastian-ecommerce-api-cneebwapd4becrgf.eastus-01.azurewebsites.net/api/Products')
    if (response.ok) {
      const apiProducts = await response.json()
      products.value = apiProducts
    } else {
      console.error('Error loading products from API, using fallback data')
      // Fallback data con imágenes que funcionan
      products.value = [
        { id: 1, name: 'Smartphone Samsung', description: 'Teléfono inteligente', price: 699.99, stock: 50, categoryId: 1, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true },
        { id: 2, name: 'Laptop HP', description: 'Laptop para profesionales', price: 1299.99, stock: 25, categoryId: 1, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true },
        { id: 3, name: 'Camiseta Nike', description: 'Camiseta deportiva', price: 29.99, stock: 200, categoryId: 2, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true }
      ]
    }
  } catch (error) {
    console.error('Error fetching products:', error)
    // Fallback data con imágenes que funcionan
    products.value = [
      { id: 1, name: 'Smartphone Samsung', description: 'Teléfono inteligente', price: 699.99, stock: 50, categoryId: 1, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true },
      { id: 2, name: 'Laptop HP', description: 'Laptop para profesionales', price: 1299.99, stock: 25, categoryId: 1, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true },
      { id: 3, name: 'Camiseta Nike', description: 'Camiseta deportiva', price: 29.99, stock: 200, categoryId: 2, imageUrl: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAwIiBoZWlnaHQ9IjMwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPjMwMHgzMDA8L3RleHQ+PC9zdmc+', available: true }
    ]
  }
}

const addToCart = (product: Product) => {
  alert(`${product.name} agregado al carrito`)
  // Aquí conectarías con el store de Pinia
}

onMounted(() => {
  loadProducts()
})
</script>

<style scoped>
.products-view {
  max-width: 1200px;
  margin: 0 auto;
}

.search-input {
  width: 100%;
  max-width: 400px;
  padding: 0.5rem;
  margin-bottom: 2rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.product-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 1rem;
  text-align: center;
}

.product-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
}

.product-info h3 {
  margin: 1rem 0 0.5rem;
}

.product-description {
  color: #666;
  margin-bottom: 0.5rem;
}

.product-price {
  font-size: 1.5rem;
  font-weight: bold;
  color: #2c3e50;
  margin: 0.5rem 0;
}

.product-stock {
  color: #666;
  margin-bottom: 1rem;
}

.add-to-cart-btn {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

.add-to-cart-btn:hover {
  background-color: #2980b9;
}
</style>