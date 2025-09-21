<template>
  <div id="app">
    <nav class="navbar">
      <h1>E-commerce</h1>
      <div class="nav-links">
        <router-link to="/products">Productos</router-link>
        <router-link to="/cart">Carrito</router-link>
        <router-link to="/orders">Pedidos</router-link>
      </div>
    </nav>
    
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
// App principal
</script>

<style scoped>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background-color: #2c3e50;
  color: white;
}

.nav-links {
  display: flex;
  gap: 1rem;
}

.nav-links a {
  color: white;
  text-decoration: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
}

.nav-links a:hover {
  background-color: #34495e;
}

.main-content {
  padding: 2rem;
}
</style>