import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import { createPinia } from 'pinia'
import App from './App.vue'
import ProductsView from './views/ProductsView.vue'
import CartView from './views/CartView.vue'

const routes = [
  { path: '/', redirect: '/products' },
  { path: '/products', component: ProductsView },
  { path: '/cart', component: CartView }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const pinia = createPinia()
const app = createApp(App)

app.use(router)
app.use(pinia)
app.mount('#app')