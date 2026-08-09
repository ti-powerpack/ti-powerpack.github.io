import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    // Force Vitest to re-run when other files change
    forceRerunTriggers: [
      '**/Tests/*.txt',
	  '**/*.au3',
    ]
  }  
})