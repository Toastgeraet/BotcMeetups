<template>
  <div class="min-h-screen bg-gray-100">
    <nav class="bg-white shadow-lg">
      <div class="max-w-7xl mx-auto px-4">
        <div class="flex justify-between h-16">
          <div class="flex">
            <router-link to="/" class="flex items-center">
              <span class="text-xl font-bold">Blood on the Clocktower</span>
            </router-link>
          </div>
          <div class="flex items-center">
            <router-link to="/events" class="px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900">Events</router-link>
            <router-link to="/login" class="ml-4 px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-gray-900">Login</router-link>
          </div>
        </div>
      </div>
    </nav>
    <router-view></router-view>
  </div>
</template>