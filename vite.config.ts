import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { createNextcloudConfig } from '@nextcloud/vite-config'
import { fileURLToPath, URL } from 'node:url'

export default defineConfig(createNextcloudConfig({
  appName: 'bloodmeetup',
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  }
}))