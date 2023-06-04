<template>
  <div>
    <!-- iswelcom:是否为欢迎语模板;-->
    <AddMaterial :tplType="tplType" :templateType="templateType" :iswelcom="true" :moduleType="3" />
  </div>
</template>

<script>
import AddMaterial from '@/components/ContentCenter/AddMaterial.vue'
export default {
  components: {
    AddMaterial,
  },
  data() {
    return {
      tplType: undefined,
      templateType: 3,
    }
  },
  created() {
    this.tplType = this.$route.query.tplType
  },
}
</script>

<style></style>
