<template>
  <div class="cart-view">
    <h2>Carrito de Compras</h2>
    
    <div v-if="cartItems.length === 0" class="empty-cart">
      <p>Tu carrito está vacío</p>
      <router-link to="/products" class="continue-shopping">
        Continuar comprando
      </router-link>
    </div>

    <div v-else>
      <div class="cart-items">
        <div v-for="item in cartItems" :key="item.id" class="cart-item">
          <img :src="item.imageUrl" :alt="item.name" class="item-image" />
          <div class="item-details">
            <h3>{{ item.name }}</h3>
            <p class="item-price">${{ item.price }}</p>
          </div>
          <div class="item-quantity">
            <button @click="updateQuantity(item, -1)">-</button>
            <span>{{ item.quantity }}</span>
            <button @click="updateQuantity(item, 1)">+</button>
          </div>
          <div class="item-total">
            ${{ (item.price * item.quantity).toFixed(2) }}
          </div>
          <button @click="removeItem(item)" class="remove-btn">
            Eliminar
          </button>
        </div>
      </div>

      <div class="cart-summary">
        <div class="total">
          <strong>Total: ${{ cartTotal.toFixed(2) }}</strong>
        </div>
        <button @click="proceedToCheckout" class="checkout-btn">
          Proceder al Checkout
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

interface CartItem {
  id: number
  name: string
  price: number
  quantity: number
  imageUrl: string
}

// Carrito iniciado vacío - se carga desde localStorage
const cartItems = ref<CartItem[]>([])

// Cargar carrito desde localStorage al montar el componente
onMounted(() => {
  const savedCart = localStorage.getItem('cart')
  if (savedCart) {
    cartItems.value = JSON.parse(savedCart)
  }
})

// Función para guardar carrito en localStorage
const saveCart = () => {
  localStorage.setItem('cart', JSON.stringify(cartItems.value))
}

const cartTotal = computed(() => {
  return cartItems.value.reduce((total, item) => total + (item.price * item.quantity), 0)
})

const updateQuantity = (item: CartItem, change: number) => {
  item.quantity += change
  if (item.quantity <= 0) {
    removeItem(item)
  } else {
    saveCart()
  }
}

const removeItem = (item: CartItem) => {
  const index = cartItems.value.findIndex(i => i.id === item.id)
  if (index > -1) {
    cartItems.value.splice(index, 1)
    saveCart()
  }
}

const proceedToCheckout = () => {
  alert('Procesando checkout...')
  // Aquí redirigirías al proceso de checkout
}
</script>

<style scoped>
.cart-view {
  max-width: 800px;
  margin: 0 auto;
}

.empty-cart {
  text-align: center;
  padding: 2rem;
}

.continue-shopping {
  display: inline-block;
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background-color: #3498db;
  color: white;
  text-decoration: none;
  border-radius: 4px;
}

.cart-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  border-bottom: 1px solid #eee;
}

.item-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 4px;
}

.item-details {
  flex: 1;
}

.item-details h3 {
  margin: 0 0 0.5rem;
}

.item-price {
  color: #666;
  margin: 0;
}

.item-quantity {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.item-quantity button {
  width: 30px;
  height: 30px;
  border: 1px solid #ddd;
  background: white;
  cursor: pointer;
  border-radius: 4px;
}

.item-total {
  font-weight: bold;
  min-width: 80px;
  text-align: right;
}

.remove-btn {
  background-color: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem;
  border-radius: 4px;
  cursor: pointer;
}

.cart-summary {
  margin-top: 2rem;
  padding: 1rem;
  border-top: 2px solid #eee;
  text-align: right;
}

.total {
  font-size: 1.5rem;
  margin-bottom: 1rem;
}

.checkout-btn {
  background-color: #27ae60;
  color: white;
  border: none;
  padding: 1rem 2rem;
  font-size: 1.1rem;
  border-radius: 4px;
  cursor: pointer;
}

.checkout-btn:hover {
  background-color: #229954;
}
</style>