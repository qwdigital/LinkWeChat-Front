import { createRouter, createWebHistory, createWebHashHistory } from 'vue-router'
import { constantRoutes, fixedRoutes } from '@/router/routes'
import permission from './permission'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: constantRoutes.concat(fixedRoutes),
})
permission(router)

export default router
