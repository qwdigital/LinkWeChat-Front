<template>
  <div>
    <AddMaterial talkType="0" :talkId="talkId" :moduleType="2" />
  </div>
</template>

<script>
import AddMaterial from '@/components/ContentCenter/AddMaterial.vue'
export default {
  name: 'talk-add',
  data() {
    return {
      talkType: '',
      talkId: '',
    }
  },
  components: { AddMaterial },
  mounted() {
    // this.talkType = this.$route.query.type
    if (this.$route.query.id) {
      this.talkId = this.$route.query.id
    }
  },
}
</script>

<style></style>
