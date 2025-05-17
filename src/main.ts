import { generateFilePath } from '@nextcloud/router'
import { getRequestToken } from '@nextcloud/auth'
import { translate, translatePlural } from '@nextcloud/l10n'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import i18n from './i18n'

// Set up global variables
// @ts-ignore
__webpack_public_path__ = generateFilePath('bloodmeetup', '', 'js/')
// @ts-ignore
window.t = translate
// @ts-ignore
window.n = translatePlural
// @ts-ignore
window.OC = window.OC || {}
// @ts-ignore
window.OC.requestToken = getRequestToken()

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(i18n)

app.mount('#app')