import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte()],
  build: {
    minify: false,
    outDir: "../inst/www",
    sourcemap: true,
    emptyOutDir: false,
  },
  //base: "",
});
