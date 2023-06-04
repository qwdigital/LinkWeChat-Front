<template>
  <div>
    <PosterAdd :id="id" />
  </div>
</template>

<script>
import PosterAdd from '../components/PosterAdd.vue'
export default {
  name: 'posterAdd',
  components: { PosterAdd },
  data() {
    return {
      id: null,
    }
  },
  mounted() {
    if (this.$route.query.id) {
      this.id = this.$route.query.id
    }
  },
}
</script>

<style></style>
