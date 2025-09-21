<template>
  <div class="orders-view">
    <h2>Mis Pedidos</h2>
    
    <div v-if="orders.length === 0" class="no-orders">
      <p>No tienes pedidos aún</p>
      <router-link to="/products" class="start-shopping">
        Comenzar a comprar
      </router-link>
    </div>

    <div v-else class="orders-list">
      <div v-for="order in orders" :key="order.id" class="order-card">
        <div class="order-header">
          <h3>Pedido #{{ order.id }}</h3>
          <span class="order-status" :class="order.status.toLowerCase()">
            {{ order.status }}
          </span>
        </div>
        
        <div class="order-details">
          <p><strong>Fecha:</strong> {{ formatDate(order.orderDate) }}</p>
          <p><strong>Total:</strong> ${{ order.total.toFixed(2) }}</p>
          <p><strong>Dirección:</strong> {{ order.shippingAddress }}</p>
        </div>

        <div class="order-items">
          <h4>Productos:</h4>
          <div v-for="detail in order.details" :key="detail.id" class="order-item">
            <span>{{ detail.productName }}</span>
            <span>x{{ detail.quantity }}</span>
            <span>${{ detail.unitPrice.toFixed(2) }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface OrderDetail {
  id: number
  productId: number
  productName: string
  quantity: number
  unitPrice: number
}

interface Order {
  id: number
  userId: number
  total: number
  status: string
  shippingAddress: string
  paymentMethod: string
  orderDate: Date
  details: OrderDetail[]
}

const orders = ref<Order[]>([])

const loadOrders = async () => {
  // Datos de ejemplo - en producción vendría de la API
  orders.value = [
    {
      id: 1,
      userId: 1,
      total: 729.98,
      status: 'Entregado',
      shippingAddress: 'Av. Principal 123, Lima',
      paymentMethod: 'Tarjeta de Crédito',
      orderDate: new Date('2024-09-15'),
      details: [
        { id: 1, productId: 1, productName: 'Smartphone Samsung', quantity: 1, unitPrice: 699.99 },
        { id: 2, productId: 3, productName: 'Camiseta Nike', quantity: 1, unitPrice: 29.99 }
      ]
    },
    {
      id: 2,
      userId: 1,
      total: 1299.99,
      status: 'En Proceso',
      shippingAddress: 'Av. Principal 123, Lima',
      paymentMethod: 'Transferencia',
      orderDate: new Date('2024-09-18'),
      details: [
        { id: 3, productId: 2, productName: 'Laptop HP', quantity: 1, unitPrice: 1299.99 }
      ]
    }
  ]
}

const formatDate = (date: Date) => {
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

onMounted(() => {
  loadOrders()
})
</script>

<style scoped>
.orders-view {
  max-width: 900px;
  margin: 0 auto;
}

.no-orders {
  text-align: center;
  padding: 2rem;
}

.start-shopping {
  display: inline-block;
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background-color: #3498db;
  color: white;
  text-decoration: none;
  border-radius: 4px;
}

.order-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  padding: 1.5rem;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.order-header h3 {
  margin: 0;
}

.order-status {
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: bold;
  text-transform: uppercase;
}

.order-status.pendiente {
  background-color: #ffeaa7;
  color: #d63031;
}

.order-status.confirmado {
  background-color: #81ecec;
  color: #00b894;
}

.order-status.enproceso {
  background-color: #a29bfe;
  color: #6c5ce7;
}

.order-status.enviado {
  background-color: #fd79a8;
  color: #e84393;
}

.order-status.entregado {
  background-color: #00b894;
  color: white;
}

.order-status.cancelado {
  background-color: #fab1a0;
  color: #e17055;
}

.order-details {
  margin-bottom: 1rem;
}

.order-details p {
  margin: 0.25rem 0;
}

.order-items h4 {
  margin: 1rem 0 0.5rem;
}

.order-item {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-bottom: 1px solid #f0f0f0;
}

.order-item:last-child {
  border-bottom: none;
}
</style>